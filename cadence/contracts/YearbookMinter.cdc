/*
* YearbookMinter is a public contract, which shocases resource-oriented nature
* of Cadence programm language. 
*/

import FungibleToken from "./standard/FungibleToken.cdc"
import FlowToken from "./standard/FlowToken.cdc"


/*
* The "head" of every contract definition consists of 3 parts:
* - access modifier - pub | access(account) 
* - reserved keyword "contract"
* - name of the contract - this needs to be unique within account, but not across the whole chain
* Some examples:
*   pub contract Basic { ... }
*   pub contract interface FungibleToken { ... }
*/ 
pub contract YearbookMinter{
    /* 💡 Events definitions */
    
    // Emitted when new Yearbook resource is created and hold address
    pub event YearbookCreated(owner: Address)
    // Emitted when "signer" account leaves a "message" in owner's yearbook
    pub event YearbookSigned(signer: Address, owner: Address, message: String) 

    // We want to prevent aggressive and impolite messages and make the experience fun and friendly for everyone.
    // In order to do this, we will create a dictionary of allowed messages and allow to add predefined messages
    pub let allowedMessages: {String: String};

    // We will define an empty resource interface, so we can later use it to identify the owner
    // of Yearbook resource
    pub resource interface Owner {}
    
    /* 💡 Implementation of Yearbook resource */
    // Yearbook is a resource that contains messages left by other owners as well
    // as public function, which allows to add or alter message
    // Docs - Resources: 
    // 👉 https://docs.onflow.org/cadence/language/resources/
    pub resource Yearbook: Owner{
        // Messages will be stored in this dictionary 
        // 
        // Docs - Dictionaries: 
        // 👉 https://docs.onflow.org/cadence/language/values-and-types/#dictionaries
        pub let messages: {Address: String}

        // adds a message into "messages" dictionary using signer's address as key
        // 
        // Since there is no "msg.sender" in Cadence we need another way to "legitibly" get the address of the signer. 
        // In order to do this, we will ask them to pass private capability only they can have.
        // It's possible to circumvent this, if someone will store their "Owner" capability as
        // public. But we can't see the incentive to do this 😛
        // 
        // Read more about "msg.sender": 👉 https://docs.onflow.org/cadence/msg-sender
        pub fun leaveMessage(messageKey: String, capability: &Yearbook{Owner}){
            // "owner" field on capability is an Optional, so we are force unwrapping it 
            // in order to retrieve address of the owner from it.
            // 
            // Docs - Optionals: 
            // 👉 https://docs.onflow.org/cadence/language/values-and-types/#optionals
            let signer = capability.owner!.address

            // We want to store only allowed messages
            let message = YearbookMinter.allowedMessages[messageKey]!

            // We update the dictionary that holds messages
            // 💡 Notice it will overwrite previously stored message!
            self.messages[signer] = message

            // Events are emitted using reserved word "emit" followed by the name of the event
            // and passing all the required arguments
            emit YearbookSigned(signer: signer, owner: self.owner!.address, message: message)
        }

        // Since we have defined a field on a esource, we need to implement "init" method
        // to set it's initial value - empty dictionary
        init(){
            self.messages = {};
        }
    }

    // Since resources can be created only within contract where they are defined, 
    // we will expose public method "createYearbook" so anyone could call it.
    pub fun createYearbook(capability: &FlowToken.Vault{FungibleToken.Balance}): @Yearbook{
        // We will use the same pattern, but we will ask for public capability to FlowToken.Vault
        // resource, since every account is created with one in it's storage
        let owner = capability.owner!.address

        // We use reserved "create" keyword to construct new instance of a resource
        let book <- create Yearbook()
        
        // Emit event that new yearbook is created
        emit YearbookCreated(owner: owner )
        
        // Lastly, we will return resource to whoever called this function
        return <- book
    }

    init(){
        self.allowedMessages = {
            "hello": "Hello, my friend",
            "sup": "Suuuuuup!",
            "cya": "See you, around!",
            "later": "Later, Aligator!"
        }
    }
}