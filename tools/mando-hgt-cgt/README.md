WARNING: This tool (HGT-CGT Version) is currently non functional.

Fork of MANDO inference tool (https://github.com/stephan-klein/ge-sc-machine) which supports running mando from command line and thus saving the overhead of running an HTTP Server.

This specific cgt version included a HGT Model pretrained with contracts from CGT (github.com/gsalzer/cgt) and Minimal Reentrancy Contracts (https://github.com/lmfuerst/DA_Testdaten)

Available Docker Images:
- `git clone https://github.com/stephan-klein/ge-sc-machine && cd ge-sc-machine`
- `docker build . -t smartbugs/mando-hgt-cgt:0.1`