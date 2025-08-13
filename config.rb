wiki_opts = {
  base_path: '/wiki',
  allow_uploads: 'dir',
  live_preview: true,
  css: 'custom.css',       # Your custom CSS file
  show_all: true,
  universal_toc: true
}

Precious::App.set(:wiki_options, wiki_opts)

Precious::App.set(:port, 4567)
Precious::App.set(:bind, '127.0.0.1')
Precious::App.set(:log_level, :debug)
