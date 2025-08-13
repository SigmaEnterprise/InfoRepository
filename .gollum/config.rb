# config.rb - Gollum Configuration File

wiki_opts = {
  base_path: '/wiki',         # Equivalent to --base-path /wiki
  allow_uploads: 'dir',       # Equivalent to --allow-uploads dir
  live_preview: true,         # Enable live preview mode
  css: true,                  # Equivalent to --css (uses <wiki-root>/custom.css)
  show_all: true,             # Show all files
  universal_toc: true         # Generate a table of contents for all pages
}

Precious::App.set(:wiki_options, wiki_opts)

# Network and server settings
Precious::App.set(:port, 4567)             # Equivalent to --port 4567
Precious::App.set(:bind, '0.0.0.0')      # Equivalent to --host 127.0.0.1
Precious::App.set(:log_level, :debug)      # Verbose logging
