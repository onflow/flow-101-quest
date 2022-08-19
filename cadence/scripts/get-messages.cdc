import YearbookMinter from "../contracts/YearbookMinter.cdc"

pub fun main(owner: Address): {Address: String}{
    let yearbookReference = getAccount(owner)
        .getCapability(YearbookMinter.publicPath)
        .borrow<&YearbookMinter.Yearbook>() 
        ?? panic(YearbookMinter.errNoYearbook)
    
    return yearbookReference.messages
}