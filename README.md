# BigSpicy - Merging SPEF, Verilog and Spice information into Circuit protobuf and generating the spice file <br/>
This repo shows the steps for merging the SPEF, verilog and spice netlist into a circuit protobuf and generating the spice file of the design which can further be used to perform various tests and analysis.<br/>
In this repo, I have used the design of traffic light controller implemented using SKY130 PDKS. The RTL to GDS2 flow of the given design can be referred from the following github repo.<br/>
https://github.com/majilokesh/iiitb_tlc <br/>

## FLOWCHART : <br/>
![200117467-c5c6d165-5011-4002-9b82-d756f3bbd48d](https://user-images.githubusercontent.com/64605104/206892403-9238ee48-5b2f-43e7-86d4-9f81d6f67f62.png)
<br/>
## PREREQUISITES : <br/>
   
To install the python dependencies, follow the below steps: <br/>
```
git clone https://github.com/majilokesh/bigspicy_iiitb_tlc
cd bigspicy_iiitb_tlc/
sudo apt-get update
pip install -e ".[dev]"
pip install -r requirements.txt
sudo apt install -y protobuf-compiler iverilog
```
<br/>

Another prerequisite for this step is to compile protobufs into python file.(_pb2.py).<br/>
To compile the protobufs, type the below command in terminal in the bigspicy_iiitb_tlc (cloned_repo) directory:<br/>
```
git submodule update --init  
protoc --proto_path vlsir vlsir/*.proto vlsir/*/*.proto --python_out=.
protoc proto/*.proto --python_out=.
```
We also need tools like Xyce and XDM installed.<br/>
To install the mentioned tools use the following links:<br/>
XYCE: <br/>
https://xyce.sandia.gov/documentation/BuildingGuide.html <br/>
XDM: <br/>
https://github.com/Xyce/XDM <br/>
## Converting the PDKs: <br/>
First step is to convert the PDKs into Xyce format.<br/>
To convert the PDK's go to the directory where XDM is installed and type the following command:<br/>
```
xdm_bdl -s hspice "path to the pdk"/"file to be converted" -d lib
```
## Merging <br/>
We merge the files into circuit protobuf(final.pb) which is used to generate the whole module spice models and to conduct the various tests using Xyce.<br/>
To merge the files, follow the below steps in the bigspicy_iiitb_tlc directory: <br/>
```
./bigspicy.py \
   --import \
   --spef example_inputs/iiitb_tlc/iiitb_tlc.spef \
   --spice lib/sky130_fd_sc_hd.spice \
   --verilog example_inputs/iiitb_tlc/iiitb_tlc_synth.v \
   --spice_header lib/sky130_fd_pr__pfet_01v8.pm3.spice \
   --spice_header lib/sky130_fd_pr__nfet_01v8.pm3.spice \
   --spice_header lib/sky130_ef_sc_hd__decap_12.spice \
   --spice_header lib/sky130_fd_pr__pfet_01v8_hvt.pm3.spice \
   --top iiitb_tlc \
   --save final.pb \
```
This will generate final.pb file.<br/>
To specify the location of the final.pb file, go to bigspicy.py file and search for "def withoptions()" function. Change the "output_dir" variable to your desired path.<br/>

## Generating whole-module spice file <br/>
After generating the "final.pb" file, we now generate the spice file("spice.sp" in this case) for our design which can be further used to run tests.<br/>
This step takes the converted pdks (in xyce format), and the design as input and gives the spice file as output.<br/>
To generate the spice file, follow the below steps in bigspicy_iiitb_tlc directory: <br/>
```
./bigspicy.py --import \
    --verilog example_inputs/iiitb_tlc/iiitb_tlc_synth.v \
    --spice lib/sky130_fd_sc_hd.spice \
    --spice_header lib/sky130_fd_pr__pfet_01v8.pm3.spice \
    --spice_header lib/sky130_fd_pr__nfet_01v8.pm3.spice \
    --spice_header lib/sky130_ef_sc_hd__decap_12.spice \
    --spice_header lib/sky130_fd_pr__pfet_01v8_hvt.pm3.spice \
    --save final.pb \
    --top iiitb_tlc \
    --flatten_spice --dump_spice spice.sp
```
The above steps will generate "spice.sp" file in the mentioned directory.<br/>

## Future Works <br/>
Presently we are working on performing tests on the generated spice file "spice.sp".<br/>
We are trying to find the path delay for few paths using Xyce and compare the same with other available tools. <br/>
We expect this to be a lot faster method for timing analysis than the other tools available now.<br/>


## ACKNOWLEDGMENTS <br/>
- Kunal Ghosh, Director, VSD Corp. Pvt. Ltd.<br/>
- Arya Reais-Parsi, PhD Candidate at University of California, Berkeley<br/>
- Madhav Rao, Professor, IIIT-Bangalore<br/>
- Nanditha Rao, Professor, IIIT-Bangalore<br/>

