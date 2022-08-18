import YearbookMinter from "../contracts/YearbookMinter.cdc"

transaction(yearbookOwner: Address, messageKey: String){
    prepare(signer: AuthAccount){
        let signerRef = signer
            .getCapability(/public/Yearbook)
            .borrow<&YearbookMinter.Yearbook>() 
            ?? panic("Specified Account ".concat(yearbookOwner.toString()).concat(" don't have Yearbook"))

        let recieverRef = getAccount(yearbookOwner)
            .getCapability(/public/Yearbook)
            .borrow<&YearbookMinter.Yearbook>()
            ?? panic("Your account does not have Yearbook in it's storage")

        recieverRef.leaveMessage(messageKey: messageKey, capability: signerRef)
    }
}