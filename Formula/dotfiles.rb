class Dotfiles < Formula
  desc "Personal dotfiles configuration for macOS development environment"
  homepage "https://github.com/swibrow/dotfiles"
  head "https://github.com/swibrow/dotfiles.git", branch: "main"

  # Use a specific version/tag when you create releases
  # url "https://github.com/swibrow/dotfiles/archive/refs/tags/v1.0.0.tar.gz"
  # sha256 "YOUR_SHA256_HERE"

  depends_on "stow"
  depends_on "git"

  def install
    # Install to a temporary location first
    libexec.install Dir["*"]

    # Create a bin script for management
    (bin/"dotfiles-install").write <<~EOS
      #!/bin/bash
      set -e

      DOTFILES_DIR="${HOME}/dotfiles"

      echo "Installing dotfiles to ${DOTFILES_DIR}..."

      # Clone or update dotfiles
      if [ -d "${DOTFILES_DIR}" ]; then
        cd "${DOTFILES_DIR}"
        git pull origin main
      else
        git clone https://github.com/swibrow/dotfiles.git "${DOTFILES_DIR}"
      fi

      cd "${DOTFILES_DIR}"

      # Run the install script
      if [ -f "./install" ]; then
        ./install
      else
        # Fallback to manual stow
        for dir in */; do
          if [ -d "$dir" ] && [ "$dir" != "homebrew-tap/" ] && [ "$dir" != "Formula/" ]; then
            stow "$dir"
          fi
        done
      fi

      echo "Dotfiles installation complete!"
      echo "Please restart your terminal or run: source ~/.zshrc"
    EOS

    (bin/"dotfiles-update").write <<~EOS
      #!/bin/bash
      set -e

      DOTFILES_DIR="${HOME}/dotfiles"

      if [ ! -d "${DOTFILES_DIR}" ]; then
        echo "Dotfiles not found. Run 'dotfiles-install' first."
        exit 1
      fi

      cd "${DOTFILES_DIR}"
      git pull origin main

      # Re-stow everything
      for dir in */; do
        if [ -d "$dir" ] && [ "$dir" != "homebrew-tap/" ] && [ "$dir" != "Formula/" ]; then
          stow -R "$dir"
        fi
      done

      echo "Dotfiles updated!"
    EOS

    (bin/"dotfiles-uninstall").write <<~EOS
      #!/bin/bash
      set -e

      DOTFILES_DIR="${HOME}/dotfiles"

      if [ ! -d "${DOTFILES_DIR}" ]; then
        echo "Dotfiles not found."
        exit 1
      fi

      cd "${DOTFILES_DIR}"

      # Unstow everything
      for dir in */; do
        if [ -d "$dir" ] && [ "$dir" != "homebrew-tap/" ] && [ "$dir" != "Formula/" ]; then
          stow -D "$dir" 2>/dev/null || true
        fi
      done

      echo "Dotfiles unlinked. Directory remains at ${DOTFILES_DIR}"
    EOS

    # Make scripts executable
    bin.children.each { |f| f.chmod 0755 }
  end

  def post_install
    system bin/"dotfiles-install"
  end

  def caveats
    <<~EOS
      Dotfiles formula installed!

      Available commands:
        dotfiles-install   - Install/setup dotfiles
        dotfiles-update    - Update dotfiles from git
        dotfiles-uninstall - Remove dotfile symlinks

      To complete setup, run:
        dotfiles-install

      Then restart your terminal or run:
        source ~/.zshrc
    EOS
  end

  test do
    assert_predicate bin/"dotfiles-install", :exist?
    assert_predicate bin/"dotfiles-update", :exist?
    assert_predicate bin/"dotfiles-uninstall", :exist?
  end
end