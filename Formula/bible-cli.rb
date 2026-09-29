class BibleCli < Formula
  desc "Offline-first command-line Bible reader"
  homepage "https://vmrocha.github.io/bible-cli/"
  url "https://github.com/vmrocha/bible-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "18671ab07fef13fd281925d523226cbbf19f3001e3a6597390ba57a87326722d"
  license "MIT"
  head "https://github.com/vmrocha/bible-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/vmrocha/bible-cli/internal/buildinfo.version=v#{version}
      -X github.com/vmrocha/bible-terminal/internal/buildinfo.version=v#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"bible", ldflags:), "./cmd/bible"
    generate_completions_from_executable(bin/"bible", "completion")
  end

  test do
    assert_match "bible v#{version}", shell_output("#{bin}/bible version")
    assert_match "For God so loved the world", shell_output("#{bin}/bible read 'John 3:16' --plain")
  end
end
