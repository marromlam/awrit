class Awrit < Formula
  desc "Terminal graphical web browser for Kitty"
  homepage "https://github.com/marromlam/awrit"
  url "https://github.com/marromlam/awrit/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "68503130ca8c739acec4b774db8c2a48143aafdfe68b77ae77c509f9ba80a96c"
  license "BSD-3-Clause"

  depends_on "oven-sh/bun/bun"
  depends_on "rust" => :build

  def install
    libexec.install Dir["*"]
    cd libexec do
      # Install JS dependencies and build native module
      system "bun", "install"
    end
    # Wrapper that uses Homebrew's bun to run the TypeScript runner
    (bin/"awrit").write <<~SH
      #!/usr/bin/env bash
      set -e
      cd "#{libexec}"
      exec "$(which bun)" run "#{libexec}/src/runner" "$@"
    SH
  end

  test do
    output = shell_output("#{bin}/awrit --help")
    assert_match "Usage:", output
  end
end
