require 'formula'

class Ethereum < Formula
  version '1.4.9'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 23
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '53e81be07fd86d6d22640599f47e0f764daf68bfb7ab9e8fa4932a5395745400' => :yosemite
    sha256 'd0fa28db5fc397ccd0fb83983e5d57bec2247737c3055e2887eee7076c7b37c4' => :el_capitan
  end

  devel do
    bottle do
      revision 226
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'f446e9089a2ad98e8025733da887d3cf02e074ad1500ecd8a5b1e0d7dc81a17d' => :yosemite
      sha256 'f18fd6ff3888e2ae02221daa079c97c301c5269a14488aabb7ab878fbc8fc7f1' => :el_capitan
    end

    version '1.5.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
