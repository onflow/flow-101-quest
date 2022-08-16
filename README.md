
# Flow Yearbok 

description goes here

## Curriculum
- Learn how to use Flow CLI for development
- Create a testnet account on Flow
- Send a transaction to sign the 'Flow Yearbook' to make it official!

Complete this quest to earn your exclusive proof of knowledge certification NFT (FLOAT) as well as a chance to get a super-rare Flow Swag Box! On this road we will be your guide, so you won’t lose track and keep being motivated to complete it.

## Prerequisites 
Let's make sure we have our rulers and calculator ready for class! You'll need these two items on your computer before we dive in: 

#### 1. Git
You can follow the [GitHub guide]() on how to install Git. 

#### 2. Flow CLI
Visit the [Flow CLI Installation](https://developers.flow.com/tools/flow-cli/install) documentation & follow the instructions. You just need to run a single command in your terminal! If you already have it installed, make sure it’s the latest version.

## Step 1 - Start the Flow CLI
First things first, you will need to start the Flow CLI in order to use commands.
```javascript
flow init
```
You should see something like this: 
```Configuration initialized
Service account: 0xf8d6e0586b0a20c7

Start emulator by running: 'flow emulator' 
Reset configuration using: 'flow init --reset'
```

## Step 2 - Create your Testnet Account
Before we can sign the yearbook, we'll need our own account! Luckily for us, we just need to run a simple command with the Flow CLI.

#### 1. Create a Testnet Account
```javascript
flow accounts create
```

#### 2. Name your Account
Name your new account `hero` and follow the rest of the instructions on screen.

```
Enter an account name: hero
```
> 💡You can pick any name, we are trying to keep the instructions in line with your experience. If you would decide to name your account differently, please use that name everywhere we refer to `hero` account and address.
> 

#### 3. Set your network to Flow Testnet
```
Use the arrow keys to navigate: ↓ ↑ → ← 
? Choose a network: 
    Local Emulator
  ▸ Flow Testnet
    Flow Mainnet
```

#### 4. Save Account Info

```
✔ Flow Testnet

❗ This command will perform the following:
 - Generate a new ECDSA P-256 public and private key pair.
 - Save the private key to hero.private.json and add it to .gitignore.
 - Create a new account on Flow Testnet paired with the public key.
 - Save the newly-created account to flow.json.


? Do you want to continue? [y/N] y
```

#### 5. Fund your Testnet Account
```
Please complete the following steps in a web browser:
 1. Complete the captcha challenge.
 2. Click the 'Create Account' button.
 3. Return to this window.

✔ Press <ENTER> to open in your browser...: █
```

Once you press `<ENTER>`, your browser will be automatically directed to the [Flow Testnet Faucet](https://testnet-faucet.onflow.org/) with your account information **pre-populated**. 

The only actions that is required are: 

```
Please complete the following steps in a web browser:
 1. Complete the captcha challenge.
 2. Click the 'Create Account' button.
 3. Return to this window.

You can also navigate to the link manually: https://testnet-faucet.onflow.org/?key=<key_that_is_pre_populated>

Waiting for your account to be created, please finish all the steps in the browser...
```

// TODO: Add gif of Funding Account (Kim)

#### 6. You're all set!

```
🎉 New account created with address 0xebeb17c521a0d375 and name hero.

Here’s a summary of all the actions that were taken:
 - Added the new account to flow.json.
 - Saved the private key to hero.private.json.
 - Added hero.private.json to .gitignore.
```

After you finish all the steps, you will notice that 2 new files. 
1) `hero.private.json` 
2) `flow.json`  

If you inspect the files, you should see the address and private key for your freshly minted account 👍!