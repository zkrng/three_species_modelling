# 3-species model using ode45 solver 

This code runs the commputation of the Yodzis-Innes 3-species model using ode45 solver in MATLAB. The work was done  in the course of Basics of Mathematical modelling, University of Eastern Finland, 2020. Refer to the [UEFK01_report_3-species_model_v2.pdf][report] for more details.

## Run the code
Start the computation by running :
```sh
main
```
Run two studied systems as mentioned in report:
```sh
run_studied_systems
```
Examining the varying parameters in Yodzis-Innes 3-species model:
```sh
run_param
```

## Notes
 - It might take ~15 minutes for the whole program to finish (RAM 16GB, AMD Ryzen 3 PRO)
 - The program saves result images to these folders a 'figures' folder, with eight subfolders naming R0, C0, xc, xp, yc, yp, S1 and S2 (as attached 'figures' folder).

[//]:#

   [report]: <https://github.com/zkrng/three_species_modelling/blob/main/UEFK01_report_3-species_model_v2.pdf>
