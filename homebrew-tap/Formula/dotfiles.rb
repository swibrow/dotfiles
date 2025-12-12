class Dotfiles < Formula
  desc "Personal dotfiles configuration for macOS development environment"
  homepage "https://github.com/swibrow/dotfiles"
  url "https://github.com/swibrow/dotfiles/archive/refs/heads/main.tar.gz"
  version "1.0.0"
  sha256 :no_check
  license "MIT"

  depends_on "stow"
  depends_on "git"
  depends_on "fzf"
  depends_on "jq"
  depends_on "ripgrep"
  depends_on "bat"
  depends_on "starship"
  depends_on "tmux"
  depends_on "neovim"
  depends_on "go"
  depends_on "kubectl"
  depends_on "k9s"
  depends_on "aws-cli"
  depends_on "helm"
  depends_on "go-task"
  depends_on "gcalcli"

  def install
    # Create dotfiles directory in user's home
    dotfiles_dir = ENV["HOME"] + "/.dotfiles"

    # Copy all files to the dotfiles directory
    system "mkdir", "-p", dotfiles_dir
    system "cp", "-R", ".", dotfiles_dir

    # Create symlinks using stow
    Dir.chdir(dotfiles_dir) do
      # Stow each configuration directory
      %w[
        zsh
        git
        tmux
        starship
        bat
        k9s
        aws
        task
        kubernetes
      ].each do |package|
        if Dir.exist?(package)
          system "stow", "--target=#{ENV["HOME"]}", "--restow", package
        end
      end
    end

    # Make scripts executable
    system "chmod", "+x", "#{ENV["HOME"]}/.local/scripts/*.sh"
    system "chmod", "+x", "#{ENV["HOME"]}/.local/scripts/tmux-calendar"

    # Install additional tools
    ohai "Installing additional dependencies..."

    # Source the zsh configuration
    ohai "Configuration complete!"
    ohai "Please restart your terminal or run: source ~/.zshrc"
  end

  def post_install
    ohai "Setting up dotfiles..."

    # Ensure directories exist
    system "mkdir", "-p", "#{ENV["HOME"]}/.config"
    system "mkdir", "-p", "#{ENV["HOME"]}/.local/scripts"
    system "mkdir", "-p", "#{ENV["HOME"]}/.aws/cli"

    # Initialize tmux plugin manager if not exists
    tpm_dir = "#{ENV["HOME"]}/.config/tmux/plugins/tpm"
    unless Dir.exist?(tpm_dir)
      system "git", "clone", "https://github.com/tmux-plugins/tpm", tpm_dir
    end

    # Compile Go tools if needed
    if File.exist?("#{ENV["HOME"]}/.local/scripts/tmux-calendar.go")
      system "go", "build", "-o", "#{ENV["HOME"]}/.local/scripts/tmux-calendar",
             "#{ENV["HOME"]}/.local/scripts/tmux-calendar.go"
    end
  end

  def caveats
    <<~EOS
      Your dotfiles have been installed!

      To complete the setup:

      1. Restart your terminal or run:
         source ~/.zshrc

      2. Install tmux plugins:
         Press prefix + I (Ctrl-A + I) in tmux

      3. Configure AWS credentials:
         aws configure

      4. Set up your environment variables in ~/.env

      For more information, visit:
      https://github.com/swibrow/dotfiles
    EOS
  end

  test do
    # Test that stow is working
    system "stow", "--version"

    # Test that key files exist
    assert_predicate ENV["HOME"] + "/.zshrc", :exist?
    assert_predicate ENV["HOME"] + "/.gitconfig", :exist?
  end
end