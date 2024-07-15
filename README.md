# appwrite-terraform-bootstrap

This repo aims to bootstrap the appwrite deployment process. Setting up a server on Hetzner Cloud with just a few clicks.

#### Some pre requisites:

- You will need a Hentzer Cloud Account
- You will need to have created a Project
- And within that project you will need to create a hetzner API Key/Token.
  - I have written the terraform to where if you have this Key exported in your cli then you can just run the terraform commands that way. If you want to hard code it, be my guest.

#### File Structure

```
.
├── README.md
├── appwrite-config
│   └── docker-compose.yml
├── main.tf
└── providers.tf
```

The appwrite-config contains the following:

- Their docker-compose file _[found here](https://appwrite.io/install/compose)_
- And their .env folder _[found here](https://appwrite.io/install/env)_

**Hint, this is where you control your appwrite server settings**

The main.tf file is simply what spins up the server.

Im not going to really go into details here as this is pretty well documented with inline comments. If anyone wants more info around this please feel free to reach out or submit a pr.

The providers.tf file is just whats responsible for telling terraform what provider its using to stand these resources up.

#### To Run

To run this once youve completed the following.

Clone the repo if you havent already

```
git clone https://github.com/phonkycat/appwrite-terraform-bootstrap.git
```

Run a TF plan to just make sure its using your Hetzner API key and that the code is actually going to create these resources

```
terraform plan
```

This will apply the terraform and build your sever, will take a min or two but will log everything for you.

```
terraform apply
```
