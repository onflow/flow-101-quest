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