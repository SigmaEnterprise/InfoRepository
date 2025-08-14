# Gollum configuration

wiki_opts = {
  base_path: '/wiki',            # Wiki served at /wiki
  allow_uploads: 'dir',          # Uploads to /uploads/
  live_preview: true,
  css: 'public/custom.css',
  show_all: true,
  universal_toc: true,
  math: 'katex',
  critic_markup: true,
  user_icons: 'gravatar',
  emoji: true,
  lenient_tag_lookup: true
}

Precious::App.set(:wiki_options, wiki_opts)

# Server config
Precious::App.set(:port, 4567)      # Internal port
Precious::App.set(:bind, '0.0.0.0') # Bind to all interfaces
Precious::App.set(:log_level, :debug)
