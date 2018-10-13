class Kaiju < Formula
  # Menzel_2016: "https://doi.org/10.1038/ncomms11257"
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "http://kaiju.binf.ku.dk/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/v1.6.3.tar.gz"
  sha256 "4e2b0eccebc36307d561d713c558adb8f82414a1ea1ecf448c217812b12ef5ad"

  depends_on "perl" # for gbk2faa.pl
  depends_on "python@2" # for convert_mar_to_kaiju.py

  needs :cxx11

  def install
    # https://github.com/bioinformatics-centre/kaiju/issues/92
    inreplace "util/gbk2faa.pl", "/usr/bin/perl -w", "/usr/bin/env perl"

    system "make", "-C", "src"

    # https://github.com/bioinformatics-centre/kaiju/issues/93
    rm "bin/taxonlist.tsv"

    bin.install Dir["bin/*"]
  end

  def caveats
    <<~EOS
      You must build a #{name} database before usage.
      See #{pkgshare}/README.md for details.
    EOS
  end

  test do
    Dir[bin/"kaij*"].each do |exe|
      assert_match version.to_s, shell_output("#{exe} -h 2>&1", 1)
    end
    %w[mkfmi mkbwt].each do |exe|
      assert_match exe.to_s, shell_output("#{bin}/#{exe} -h 2>&1")
    end
  end
end
