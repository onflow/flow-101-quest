# Intro to Cadence and the Yearbook Contract 📚

> 🌐 Languages: [简体中文](THEORY_ZH.md) [日本語](THEORY_JA.md)

## Introduction

Today we will learn Cadence basics by creating a basic contract. We'll use the concept of a Yearbook to illustrate a lot of Cadence's strengths over other programming languages.

> 🍬 You can jump righ into a live version of the code in this sandbox on the [Playground](https://play.onflow.org) - [https://play.onflow.org/bbcdce0a-ea52-449f-bc0e-4fddd5079f9e](https://play.onflow.org/bbcdce0a-ea52-449f-bc0e-4fddd5079f9e)

## Step 1 - Basic Contract

In this tutorial, we will use the [Flow Playground](https://play.onflow.org) - a simulated environment of the Flow blockchain, where 
we can experiment with Cadence, transactions and scripts!

It also has all the necessary features of modern IDE:
- code highlighting
- interactive language server
- code completion, etc.

Let’s define the most basic contract on Flow. In its most basic form, it is a one-liner like this:

```jsx
pub contract YearbookMinter{ }
```

It’s a perfectly viable contract, though it doesn’t do much 😅

We will define an empty resource inside of the body of our contract and call it `Yearbook`:

```jsx
pub contract YearbookMinter{
    pub resource Yearbook{ }
}
```

Resources are essential concepts in Cadence. Resources unlock richer composability options than EVM or WASM, and are a perfect fit for digital assets. Labelling something as a “Resource” tells the programming environment that this data structure represents something of tangible value and that all code that interacts with that data structure needs to follow a series of special rules that will maintain the value of that data structure.

So, what are these rules?

- Each Resource exists in exactly one place at any given time. Resources can’t be duplicated or accidentally deleted, either through programming error or malicious code.
- Ownership of a Resource is defined by where it is stored. There is no central ledger that needs to be consulted to determine ownership.
- Access to methods on a Resource is limited to the owner. For example, only the owner of a Yearbook can choose to delete it, but the owner can let anyone sign it, via capabilities.

Just like our previous version, this contract only holds the definition of the resource. 
However, instances of said resource won’t have any properties. Let’s add some!

We want a Yearbook to be able to store messages from other users, so that users can leave messages on each others' yearbooks. 
In order to enable this we will define a [Dictionary](https://docs.onflow.org/cadence/language/values-and-types/#dictionaries) called `messages`. It will use [Address](https://docs.onflow.org/cadence/language/values-and-types/#addresses) of other user as `key` and store `value` as  [String](https://docs.onflow.org/cadence/language/values-and-types/#strings-and-characters). So our dictionary type will be `{Address: String}`.

> 💡 If you are coming from Ethereum, Dictionary is something that will be called `mapping` in Solidity.
> 

After necessary changes our code should look like this:

```jsx
pub contract YearbookMinter{
    pub resource Yearbook{
        pub let messages: {Address: String}

        init(){
            self.messages = {}
        }
    }
}
```

> 💡 Notice, since we’ve added fields to our resource, we also need to implement `init` method, which would set initial values for all defined fields. We would initialize our `messages` with empty dictionary. 

We’ve defined `messages` field with `let` keyword stating that it’s immutable - it won’t be possible to reassign it to another Dictionary, 
but we want other users to be able to leave us a messages. It’s possible to change values of the dictionary within the scope, 
where it is defined - in our case, the body of `Yearbook` resource. Let’s define a `leaveMessage` function to enable this:

```jsx
pub contract YearbookMinter{
    pub resource Yearbook{
        pub let messages: {Address: String}

        pub fun leaveMessage(user: Address, message: String){
            self.messages[user] = message
        }

        init(){
            self.messages = {}
        }
    }
}
```

We are using reserved keyword `self` to access parent of current context - here it will refer to the instance of Yearbook resource, which was used to invoke our `leaveMessage` function.

### Step 1.1 - Add a `minter`

Even if we deploy this contract now, nobody will be able to use this resource. The problem is that resources should be created only within the body of the contract, where its type is defined. 

We will fix this by adding a simple function `createYearbook`:

```jsx
pub contract YearbookMinter{
    pub resource Yearbook{
        pub let messages: {Address: String}

        pub fun leaveMessage(user: Address, message: String){
            self.messages[user] = message
        }

        init(){
            self.messages = {}
        }
    }

    pub fun createYearbook(): @Yearbook{
        return <- create Yearbook();
    }
}
```

Reserved keyword `create` is used to construct new instance of resource and `<-` operator is ued to `move` resource from one place to another. 
This approach was designed in order to prevent unwanted loss of resources.

## Step 2 - Contract Improvements

### Step 2.1 - Better Detailed Yearbook

The more unique properties there are on Yearbook - the more interesting we make it!

Since resources can be transfered between accounts, let’s define the `ownerAddress` and ask it as argument during resource instantiation:

```jsx
pub contract YearbookMinter{
    pub resource Yearbook{
        pub let ownerAddress: Address
        pub let messages: {Address: String}

        pub fun leaveMessage(user: Address, message: String){
            self.messages[user] = message
        }

        init(_ owner: Address){
            self.ownerAddress = address
            self.messages = {}
        }
    }

    pub fun createYearbook(address: Address): @Yearbook{
        return <- create Yearbook(address);
    }
}
```

> 💡 We allow to set those value only once, during resource creation, but it’s possible to implement it in a way, where owner will be able to change it at will.

### Step 2.2 - Contract Events

In order to keep track of when a new Yearbook is created or someone left a message - for example, to reflect this in your user interface - we will emit two [Events](https://docs.onflow.org/cadence/language/events/#gatsby-focus-wrapper):

- `YearbookCreated` will be emitted, when new instance of `Yearbook` resource is created
- `YearbookSigned` will be emitted, when user left a message in Yearbook

We will put our events on top of the contract and then emit them inside of Yearbook `init` method and at the end of `leaveMessage` function: 

```jsx
pub contract YearbookMinter{    
    pub event YearbookCreated(owner: Address)
    pub event YearbookSigned(signer: Address, owner: Address, message: String) 

    pub resource Yearbook{
        pub let ownerAddress: Address
        pub let messages: {Address: String}

        pub fun leaveMessage(signer: Address, message: String){
            self.messages[signer] = message
            emit YearbookSigned(signer: signer, owner: self.ownerAddress, message: message) 
        }

        init(_ owner: Address){
            self.ownerAddress = owner
            self.messages = {}

            emit YearbookCreated(owner: owner)
        }
    }

    pub fun createYearbook(name: String, ownerAddress: Address): @Yearbook{
        return <- create Yearbook(name, ownerAddress);
    }
}
```

You technically dont *need* events, but it makes it possible to listen for these events and react to them in, for example, a web app.

### Step 2.3 - Moderate Messages

We'll mitigate trolling by providing a fixed list of messages that people can use to sign each other's Yearbooks. 
The list will be stored in form of a `{String: String}` dictionary.

```jsx
pub contract YearbookMinter{    
    pub event YearbookCreated(owner: Address)
    pub event YearbookSigned(signer: Address, owner: Address, message: String) 

    pub let allowedMessages: {String: String}

    pub resource Yearbook{
        pub let ownerAddress: Address
        pub let messages: {Address: String}

        pub fun leaveMessage(signer: Address, messageKey: String){
            if let message = YearbookMinter.allowedMessages[messageKey]{
	            self.messages[signer] = message
	            emit YearbookSigned(signer: signer, owner: self.ownerAddress, message: message) 
            } else {
                panic("Provide message key does not exist")
            }
        }

        init(_ owner: Address){
            self.ownerAddress = owner
            self.messages = {}

            emit YearbookCreated(owner: owner)
        }
    }

    init(){
        self.allowedMessages = {
            "hello": "Hello",
            "bff": "You are the best friend anyone could ask for!",
            "cya": "See you around",
            "gator": "Later, aligator!",
            "fun": "You make my life fun!"		
        }
    }

    pub fun createYearbook(ownerAddress: Address): @Yearbook{
        return <- create Yearbook(ownerAddress);
    }
}
```

`if let` construct is called [Optional Binding](https://developers.flow.com/cadence/language/control-flow#optional-binding) and it will allow us to ensure that value at provided message key exist, otherwise we will execute code in `else` block - in our case we would call `panic` with specific message to stop code execution.

### Step 2.4 - Add Public Paths and Error Messages

In order to provide better discoverability, let’s add known public and storage paths, that we would use in our interactions. We also add common error messages - it’s not a necessity and transactions can stop execution at any time via the `panic` method, but a nice practice!


```bash
pub contract YearbookMinter{    
    pub event YearbookCreated(owner: Address)
    pub event YearbookSigned(signer: Address, owner: Address, message: String) 

    pub let allowedMessages: {String: String}

    pub let storagePath: StoragePath
    pub let publicPath: PublicPath

		pub let errNoYearbook: String
		pub let errWrongMessageKey: String

    pub resource Yearbook{
        pub let ownerAddress: Address
        pub let messages: {Address: String}

        pub fun leaveMessage(signer: Address, messageKey: String){
            if let message = YearbookMinter.allowedMessages[messageKey]{
	            self.messages[signer] = message
	            emit YearbookSigned(signer: signer, owner: self.ownerAddress, message: message) 
            } else {
                panic(YearbookMinter.errWrongMessageKey)
            }
        }

        init(_ owner: Address){
            self.ownerAddress = owner
            self.messages = {}

            emit YearbookCreated(owner: owner)
        }
    }

    init(){
        self.allowedMessages = {
            "hello": "Hello",
            "bff": "You are the best friend anyone could ask for!",
            "cya": "See you around",
            "gator": "Later, aligator!",
            "fun": "You make my life fun!"		
        }

        self.storagePath = /storage/Yearbook
        self.publicPath = /public/Yearbook

		self.errNoYearbook = "Account does not have exposed Yearbook capability"
		self.errWrongMessageKey = "Provide message key does not exist"
    }

    pub fun createYearbook(ownerAddress: Address): @Yearbook{
        return <- create Yearbook(ownerAddress);
    }
}
```

While it adds a couple extra lines, it allows us to reference paths like `YearbookMinter.publicPath`, which will ensure consistency of the paths across interactions, without having to hardcode paths in our scripts.

## Step 3 - Interactions

Now when we have our contract ready, let’s define some interactions.

- `Scripts`: are used to query data from contracts and accounts (i.e. the chain). Scripts can’t modify the state of the chain. Even if you call method on the contract, which suppose to change state - those changes won’t be preserved after execution of code.
- `Transactions`: are use to *mutate* the chain, i.e. change the state of the information stored on accounts.

### Step 3.1 - Read Allowed Messages

We can read the list of allowed messages from contract code, but there should be a pragrammatic way of doing this. 
We can achieve this with simple Cadence script:

> 💡 We will be importing the improved version of the contract, deployed to `0x02` account
> 

```jsx
import YearbookMinter from 0x02

pub fun main(): [String] {
  return YearbookMinter.allowedMessages.keys
}
```

`keys` method  on the dictionary will return all available keys as array. Since our `allowedMessages` dictionary of type `{String:String}` , calling it will return us array of strings - `[String]`

### Step 3.2 - Init Account

Since we want our users to participate in this fun activity, we need to create transaction, which will mint new `Yearbook` resource, store it in signer’s storage and then expose publicly available capability.

We will also add a fail-safe switch, which will check if account already have Yearbook stored and exposed and won’t override existing one:

```jsx
import YearbookMinter from 0x02

transaction {
  prepare(signer: AuthAccount) {
    let yearbookExists = signer.getCapability(YearbookMinter.publicPath)
      .check<&YearbookMinter.Yearbook>()

    if(!yearbookExists){
      let book <- YearbookMinter.createYearbook(ownerAddress: signer.address)
      signer.save(<-book, to: YearbookMinter.storagePath)
      signer.link<&YearbookMinter.Yearbook>(YearbookMinter.publicPath, target: YearbookMinter.storagePath)
    }
  }
}
```

`.check()` method will check if capability on provided path exists and is of proper type - in our case it should be `<&YearbookMinter.Yearbook>`

`.save()` method will store newly created Yearbook into storage (notice `move` operator - `<-` - here to pass resource as first argument)

And finally `.link()` method will create and expose publicly available capability (which we will use in following transaction)

> 💡You’ve probably noticed how convenient it to use those public and storage paths - you don’t need to memorize them or refer to the contract  code and IDE will give you code suggestions as well!
> 

### Step 3.3 - Leave Message

In order to leave message in someone’s Yearbook we will need to grab publicly exposed capability from that account and call `leaveMessage` method, passing our address and message key.

```jsx
import YearbookMinter from 0x02

transaction(yearbookOwner: Address, messageKey: String){
    prepare(signer: AuthAccount){
        let yearbookReference = getAccount(yearbookOwner)
            .getCapability(YearbookMinter.publicPath)
            .borrow<&YearbookMinter.Yearbook>()
            ?? panic(YearbookMinter.errNoYearbook)

        yearbookReference.leaveMessage(signer: signer.address, messageKey: messageKey)
    }
}
```

`getAccount` method called with account address will return us instance of `PublicAccount` corresponding to that account. This will provide us access to it’s public capabilities and allow to get a reference to their Yearbook. If account don’t have capability we want, transaction will stop execution via `panic` with provided message.

After we succesfully `.borrow` a reference to Yearbook resource, we can call `leaveMessage`.

> 💡 As you might have guessed it’s easy to spoof `signer` argument, by providing ANY address and impersonate another account. It’s possible to mitigate this (to a certain extent), though we won’t cover it as this time.


### Step 3.4 - Get Yearbook messages

Finally, let’s create a script, which will get `Address` argument and try to fetch all available messages left by others.

Again, we will try to get a reference to Yearbook resource with `getAccount` and `getCapability` combo and then return value of `messages` field.

```jsx
import YearbookMinter from 0x02
pub fun main(owner: Address): {Address: String}{
    let yearbookReference = getAccount(owner)
        .getCapability(YearbookMinter.publicPath)
        .borrow<&YearbookMinter.Yearbook>() 
        ?? panic(YearbookMinter.errNoYearbook)
    
    return yearbookReference.messages
}
```

## Resources

- Flow Playground - [https://play.onflow.org/local-project](https://play.onflow.org/local-project)
- Docs: Dictionaries - [https://docs.onflow.org/cadence/language/values-and-types/#dictionaries](https://docs.onflow.org/cadence/language/values-and-types/#dictionaries)
- Docs: Resources - [https://docs.onflow.org/cadence/language/resources/](https://docs.onflow.org/cadence/language/resources/)
- Docs: Events - [https://docs.onflow.org/cadence/language/events/#gatsby-focus-wrapper](https://docs.onflow.org/cadence/language/events/#gatsby-focus-wrapper)


## COMPLETE! 

🎉 Now you know the theory behind the Yearbook contract! Make sure to complete the quest in the README.md to earn your unique Soulbound Proof-of-Knowledge NFT.
