# Docker PHP, Apache and PDO_Informix
It was very useful for me to develop with Yii2 framework >=2.0.4 and informix.
using https://github.com/edgardmessias/yii2-informix , it works 100%!!
---

**DISCLAIMER:**  
I have created this repository to connect PHP-PDO with Informix >=7.5, making my development process more efficient. This repository is currently being used in a production project running at 100% (for now). However, caution is advised, as certain data types may present issues. The use of this repository comes with no guarantees, and I do not assume any responsibility for failures of any kind.  

Below are the minimal configuration files required to generate a Docker container with support for:  
- PHP: 8.0.17  
- Apache (Debian Buster)  
- PDO_Informix v1.3.6  

The configurations are intended for installing PDO_Informix with the IBM Informix SDK.  

⚠ **WARNING: All database queries will be executed, so please carefully consider the type of query you run.**  

### Configuration  

1. Clone the project.  
2. You need an "IBM ID" to download the SDK: `ibm.csdk.4.50.FC11.LNX.tar`  
   ([Download here](https://www.ibm.com/resources/mrs/assets/packageList?source=ifxdl&lang=en_US))  
   and the PDO extension ([Download here](https://pecl.php.net/package/PDO_INFORMIX/1.3.6)).  
3. In the `informix/sqlhosts` file, update the `your_server` string to match your Informix server name.  
   You can edit the configuration files in the `apache_conf` folder.  

   **Note:** The IBM download URL (https://www.ibm.com/resources/...) is subject to change.  
4. Build the image:  
   docker build -t ifxpdo .

