#!/bin/sh

set -u
set -e

cd "$(dirname "$0")/../"
TASK_DIR="$(pwd)/tasks"
DOC_DIR="$(pwd)/doc/source"

mkdir -p "$DOC_DIR/tasks"
mkdir -p "$DOC_DIR/_static"

# generate overview graph
echo "$(./taskutil --visualize)" | dot "/dev/stdin" -Tsvg > "$DOC_DIR/_static/overview.svg"

gen_header_underline () {
	# generates a string of n many 'X' characters for a string on $1 of
	# length n. This can be used in conjunction with tr to produce arbitrary
	# header underlines for reStructuredText headers.

	underline=""
	for i in $(seq $(echo "$1" | wc -c)) ; do
		underline="X$underline"
	done

	echo "$underline"
}

# generate doc pages for each task
for task in "$TASK_DIR"/* ; do
	taskname="$(basename "$task")"
	echo "processing task $taskname... "

	# make sure the task has a taskfile
	if [ ! -e "$task/task.json" ] ; then
		echo "missing taskfile for $taskname"
		continue
	fi

	# generate a visualization
	echo "$(./taskutil --visualize $taskname)" | dot "/dev/stdin" -Tsvg > "$DOC_DIR/_static/$taskname.overview.svg"

	# generate task page
	taskpage="$DOC_DIR/tasks/$taskname.rst"
	tasktitle="Documentation for Task $taskname"

	echo "$(gen_header_underline "$tasktitle")" | tr 'X' '#' > "$taskpage"
	echo "$tasktitle" >> "$taskpage"
	echo "$(gen_header_underline "$tasktitle")" | tr 'X' '#' >> "$taskpage"
	echo "" >> "$taskpage"
	echo "" >> "$taskpage"
	echo ".. contents::" >> "$taskpage"
	echo "" >> "$taskpage"
	echo "" >> "$taskpage"
	echo "Dependency Graph" | tr 'X' '=' >> "$taskpage"
	echo "$(gen_header_underline "Dependency Graph")" |tr 'X' '=' >> "$taskpage"
	echo "" >> "$taskpage"
	echo ".. image:: ../_static/$taskname.overview.svg" >> "$taskpage"
	echo "" >> "$taskpage"

	echo "Taskfile" >> "$taskpage"
	echo "$(gen_header_underline "Taskfile")" | tr 'X' '=' >> "$taskpage"
	echo "" >> "$taskpage"
	echo ".. code-block:: json" >> "$taskpage"
	echo "	:linenos:" >> "$taskpage"
	echo "" >> "$taskpage"
	OLDIFS=$IFS
	IFS=""
	cat "$task/task.json" | while read line ; do
		printf "\t$line\n" >> "$taskpage"
	done
	IFS=$OLDIFS
	echo "" >> "$taskpage"

	# if a doc.rst exists in the task directory, add that in too...
	if [ -e "$task/doc.rst" ] ; then
		cat "$task/doc.rst" >> "$taskpage"
	fi

	# write timestamp
	echo "" >> "$taskpage"
	echo "-----" >> "$taskpage"
	echo "" >> "$taskpage"
	echo "Page generated on $(date)" >> "$taskpage"

	echo "finished processing task $taskname"
done
