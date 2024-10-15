# Site-to-Site VPN Setup Between AWS VPC and Ubuntu Machine

This guide explains how to set up a site-to-site VPN between an AWS VPC and an Ubuntu 20.04 machine using StrongSwan. The steps include creating a VPC on AWS, configuring the VPN connection, and setting up StrongSwan on Ubuntu.

## Prerequisites

- AWS account
- Ubuntu 20.04 machine (on-premise or VM)

---

## Step 1: Create VPC with a Public Subnet

1. **Go to AWS VPC Wizard**  
   In the AWS Management Console, navigate to **VPC** > **Your VPCs** > **Launch VPC Wizard**.
2. **Select “VPC with a Single Public Subnet”**  
   Choose the VPC with a Single Public Subnet option. This will automatically create a VPC, an internet gateway, a public subnet, and a route table.

   **VPC Name**: `MyVPC`  
   **CIDR Block**: `10.0.0.0/16`  
   **Subnet Name**: `PublicSubnet`  
   **Subnet CIDR Block**: `10.0.1.0/24`

![alt text]({02F5F988-2397-41D2-BBA8-EE55ED69D4F4}.png)

3. **Launch the VPC**  
   Click **Create VPC**.

![alt text]({0DFD0039-49D1-41EB-A58E-E2AD1BB132E2}.png)

---

## Step 2: Create a Customer Gateway (CGW)

A Customer Gateway (CGW) represents the external device (your Ubuntu server) that connects to the AWS VPN.

1. **Go to AWS Console** > **VPN** > **Customer Gateways** > **Create Customer Gateway**.
2. **Configure Customer Gateway**:

   - **Name**: `UbuntuCGW`
   - **Routing**: Static
   - **IP Address**: Use the public IP of your Ubuntu machine. To get this, go to `www.whatismypublicip.com`.

   ![alt text]({D3F40A18-48FF-46D2-8D8B-E0F54D1316EF}.png)

   - **BGP ASN**: Leave as default.

3. Click **Create Customer Gateway**.
![alt text]({FC6C45D1-5939-4419-802C-718473D7150A}.png)
---

## Step 3: Create a Virtual Private Gateway (VGW)
A Virtual Private Gateway (VGW) is a VPN concentrator on the AWS side of the connection.

1. **Go to AWS Console** > **VPN** > **Virtual Private Gateways** > **Create Virtual Private Gateway**.
2. **Name**: `MyVGW`  
   **ASN**: Leave default.
3. Click **Create Virtual Private Gateway**.
![alt text]({C41630C1-C3EA-48F8-8CC5-D132B64BCA98}.png)
4. **Attach the VGW to the VPC**:
   - Go to **Actions** > **Attach to VPC** > Select `MyVPC`.
![alt text]({C15C12F9-608F-4EBB-AB45-C54A2EFCF30E}.png)
---

## Step 4: Create a VPN Connection

The VPN connection represents the encrypted tunnel between the AWS VPC and your Ubuntu server.


1. **Go to AWS Console** > **VPN** > **Create VPN Connection**.
2. **Configuration**:

   - **Target Gateway**: Select the Virtual Private Gateway (VGW) created earlier.
   - **Customer Gateway**: Select the Customer Gateway (CGW) you created.
   - **Routing**: Static.
   - **Static IP Prefixes**: Enter the private IP CIDR of your Ubuntu machine (run `hostname -I` on terminal on local machine).
   ![alt text]({37E4D220-61D8-4C6A-B375-E4989DB5FE82}.png)
   - **Local IPv4 network CIDR**: Enter the private IP CIDR of your Ubuntu machine.
   - **Remote IPv4 network CIDR**: Enter the private IP CIDR of your vpc.

3. Click **Create VPN Connection**.

![alt text]({31480EDC-56C1-4F48-9499-A6584675519A}.png)

4. **Download VPN Configuration**:  
   Once the VPN connection is created, download the VPN configuration for StrongSwan from AWS. You will use this file to configure your Ubuntu machine.

![alt text]({4F2980A7-FFDE-4716-85CD-663C00308D90}.png)
---

## Step 5: Update Route Tables
Route propagation allows the VGW to propagate routes back to your on-premise Ubuntu machine.

1. **Go to AWS Console** > **VPC** > **Route Tables**.
2. **Select the Route Table** associated with your VPC.

3. **Edit Route Propagation**:

   - Go to **Route Propagation** > **Edit**.
   - Enable the propagation for the Virtual Private Gateway (VGW).

4. Save the changes.

![alt text]({8470A117-2835-4097-AFAA-186BE58D97DE}.png)
---

## Step 6: Install and Configure StrongSwan on Ubuntu

StrongSwan is the VPN software used to establish the IPsec connection on your Ubuntu machine. The configuration file from AWS contains all the necessary parameters to set up the connection.

### Install StrongSwan

SSH into your Ubuntu 20.04 machine and install StrongSwan using the following command:

```bash
sudo apt update
sudo apt install strongswan strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins libtss2-tcti-tabrmd0 -y
```

### Generate Server Keys and Certificates

#### Step 1: Generate IPsec Private Key

```bash
sudo su
sudo ipsec pki --gen --size 4096 --type rsa --outform pem > /etc/ipsec.d/private/ca.key.pem
```

#### Step 2: Create and Sign the Root Certificate

```bash
sudo ipsec pki --self --in /etc/ipsec.d/private/ca.key.pem --type rsa --dn "CN=YourVPNServerName" --ca --lifetime 3650 --outform pem > /etc/ipsec.d/cacerts/ca.cert.pem
```

#### Step 3: Generate VPN Server Private Certificate

```bash
sudo ipsec pki --gen --size 4096 --type rsa --outform pem > /etc/ipsec.d/private/server.key.pem
```

#### Step 4: Generate Host Server Certificate (Using Static IP)

```bash
sudo ipsec pki --pub --in /etc/ipsec.d/private/server.key.pem --type rsa | sudo ipsec pki --issue --lifetime 3650 --cacert /etc/ipsec.d/cacerts/ca.cert.pem --cakey /etc/ipsec.d/private/ca.key.pem --dn "CN=YourServerPublicIP" --san="YourServerPublicIP" --san="YourServerPublicIP" --flag serverAuth --flag ikeIntermediate --outform pem > /etc/ipsec.d/certs/server.cert.pem
```

### Configure StrongSwan Using AWS Configuration

1. **Edit `/etc/ipsec.conf`**:  
   Edit the contents of your `/etc/ipsec.conf` file with the steps from the downloaded AWS VPN configuration.

2. **Edit `/etc/ipsec.secrets`**:  
   Similarly, update your `/etc/ipsec.secrets` file with the credentials and secrets provided in the AWS VPN configuration.

3. **Restart StrongSwan**:

```bash
sudo systemctl restart ipsec
```
---

## Step 7: Verify the VPN Connection

This verifies that the VPN tunnel between the AWS VPC and the Ubuntu machine is active and operational.

1. **On Ubuntu**:

   - Check the status of the VPN connection:
     ```bash
     sudo ipsec status
     ```
   - Ensure that the connection is established and active.
   ![alt text]({5A3ED856-80F2-4F49-A3D5-87AE05A5CADB}.png)

2. **On AWS**:
   - Go to **VPN Connections** in the AWS console.
   - Check the **Tunnel Status** and ensure that at least one tunnel is up.
![alt text]({3EE80EDA-0E87-427F-95CA-CBFE57AA91CD}.png)
---

## Conclusion

You have successfully set up a site-to-site VPN between your AWS VPC and an Ubuntu machine using StrongSwan. Now both networks can securely communicate over an encrypted tunnel.

---
