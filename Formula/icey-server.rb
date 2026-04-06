class IceyServer < Formula
  desc "Self-hosted source-to-browser server built on icey"
  homepage "https://github.com/nilstate/icey-cli"
  url "https://github.com/nilstate/icey-cli/releases/download/v0.1.2/icey-cli-0.1.2-source.tar.gz"
  sha256 "2828e706de318ea5b76ab1610166c6de379d7e8f6fe36819abb68bcf8e4acf68"
  license "AGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "openssl@3"

  resource "icey" do
    url "https://github.com/nilstate/icey-cli/releases/download/v0.1.2/icey-2.4.3-source.tar.gz"
    sha256 "b8b4950b431c5e72b84e79352d14360c2a50e2716be49f40fb85dbd7defdb229"
  end

  def install
    resource("icey").stage buildpath/"icey"

    system "npm", "--prefix", "web", "ci"
    system "npm", "--prefix", "web", "run", "build"
    system "cmake", "-S", ".", "-B", "build",
      "-DCMAKE_BUILD_TYPE=Release",
      "-DICEY_SOURCE_DIR=#{buildpath}/icey"
    system "cmake", "--build", "build", "-j1", "--target", "icey-server"
    system "cmake", "--install", "build", "--prefix", prefix, "--component", "apps"
  end

  test do
    assert_match "icey-server", shell_output("#{bin}/icey-server --version")
  end
end
