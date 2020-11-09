# Compiled Kaldi ASR

This image contains a compiled version of
[Kaldi-ASR](https://github.com/kaldi-asr/kaldi) in `/opt/kaldi`.  To
shorten the compilation time, only certain shared libraries have been
compiled (see Dockerfile for details). Furthermore, no executables
have been compiled. To save disk space, all files but .h and .so files
have been removed from `/opt/kaldi`.
