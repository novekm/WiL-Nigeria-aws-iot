# minipupper-iot-core Terraform Module Documentation

This module includes creation of resources such as an AWS Amplify App, Cognito User Pool, Identity Pool, and User Pool Groups, and more. A main benefit the module has is the ability to dynamically create your .idn sketch files for each Mini Pupper you define in your `main.tf`.



Upon a successful  `terraform apply` a directory labeled **M5STICKCPLUS_AWS_IOT** will be created with sub folders for each Mini Pupper. Ex. **`M5STICKCPLUS_AWS_IOT/GAS1`**. In each sub folder will be additional sub folders for the corresponding device certificates/private keys, as well as a folder containing the .ino and .h files. You can simply use the .ino file to update the sketch on each Gas Sensor if using the Arduino IDE. If using the OTA update functionality, you must compile the binary and upload that file in the web browser. The files will be automatically regenerated with the up to date certificates and other necessary values if you run **`terraform destroy`** and then another **`terraform apply`**. To make global changes to all of the .ino and .h files, edit the code in **`localfile.tf`**

These files/directories are git ignored and will only be visible locally. Optionally, you could store them in a secured S3 bucket and download them as needed, as well as manage multiple versions, however that is beyond the scope of this solution at this time.

**TODO - Add more documentation as solution is worked on**
