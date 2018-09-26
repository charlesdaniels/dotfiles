c.url.start_pages = ["https://start.duckduckgo.com"]
c.content.javascript.enabled = False

c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.headers.custom = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
c.content.headers.user_agent = 'Mozilla/5.0 (Windows NT 6.1; rv:52.0) Gecko/20100101 Firefox/52.0'

config.bind(',ff', 'spawn firefox {url}')
config.bind(',m', 'spawn --userscript /usr/share/qutebrowser/userscripts/view_in_mpv')
config.bind('<Ctrl-k>', 'spawn --userscript /usr/share/qutebrowser/userscripts/qute-keepass -p ~/Dropbox/Crypted/database.kdbx', mode="insert")
config.bind('<Ctrl-p>', 'spawn --userscript /usr/share/qutebrowser/userscripts/qute-keepass -w -p ~/Dropbox/Crypted/database.kdbx', mode="insert")
config.bind('<Ctrl-u>', 'spawn --userscript /usr/share/qutebrowser/userscripts/qute-keepass -e -p ~/Dropbox/Crypted/database.kdbx', mode="insert")
