Integration of the original MANDO inference tool from https://github.com/MANDO-Project/ge-sc-machine.

The tool starts a FASTAPI server and accepts POST Requests under `localhost:5555/v1.0.0/vulnerability/detection/nodetype`, will run separate model inferance for different vulnerability types and finally return results in the HTTP Response.

Therefore `do_solidity.sh` uses curl HTTP Client to construct requests and deliver results to a .json file

Available Docker Images:
- `nguyenminh1807/sco:latest` The original authors image
- other tags under `nguyenminh1807/sco`: Seem errornous (containers do not even start or deliver 500 Error Responses)
- build yourself from github clone