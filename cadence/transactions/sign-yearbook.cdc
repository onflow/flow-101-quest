import YearbookMinter from "../contracts/YearbookMinter.cdc"

transaction(yearbookOwner: Address, messageKey: String){
    prepare(signer: AuthAccount){
        let yearbookReference = getAccount(yearbookOwner)
            .getCapability(YearbookMinter.publicPath)
            .borrow<&YearbookMinter.Yearbook>()
            ?? panic(YearbookMinter.errNoYearbook)

        yearbookReference.leaveMessage(signer: signer.address, messageKey: messageKey)
    }
}