class Awrit < Formula
  desc "Terminal graphical web browser for Kitty"
  homepage "https://github.com/marromlam/awrit"
  url "https://github.com/marromlam/awrit/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "68503130ca8c739acec4b774db8c2a48143aafdfe68b77ae77c509f9ba80a96c"
  license "BSD-3-Clause"

  def install
    libexec.install Dir["*"]
    (bin/"awrit").write <<~SH
      #!/usr/bin/env bash
      set -e
      exec "#{libexec}/awrit" ""
    SH
  end

  test do
    assert_match "awrit", shell_output("#{bin}/awrit --help", 0)
  end
end
