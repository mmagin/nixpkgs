{ stdenv, fetchurl, python3Packages, glibcLocales }:

# Packaging documentation at:
# https://github.com/untitaker/vdirsyncer/blob/master/docs/packaging.rst
let
  pythonPackages = python3Packages;
in
pythonPackages.buildPythonApplication rec {
  version = "0.16.3";
  name = "vdirsyncer-${version}";

  src = fetchurl {
    url = "mirror://pypi/v/vdirsyncer/${name}.tar.gz";
    sha256 = "0dpwbfi97ksijqng191659m8k0v215y8ld95w8gb126m4m96qpzw";
  };

  propagatedBuildInputs = with pythonPackages; [
    click click-log click-threading
    requests_toolbelt
    requests
    requests_oauthlib # required for google oauth sync
    atomicwrites
  ];

  buildInputs = with pythonPackages; [hypothesis pytest pytest-localserver pytest-subtesthack setuptools_scm ] ++ [ glibcLocales ];

  LC_ALL = "en_US.utf8";

  checkPhase = ''
    make DETERMINISTIC_TESTS=true test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pimutils/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
