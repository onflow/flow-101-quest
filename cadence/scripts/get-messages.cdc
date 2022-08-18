import YearbookMinter from "../contracts/YearbookMinter.cdc"

pub fun main(owner: Address) : {Address: String} {
    let ref = getAccount(owner)
        .getCapability(/public/Yearbook)
        .borrow<&YearbookMinter.Yearbook>()
        ?? panic("Your account does not have Yearbook in it's storage")
    
    return ref.messages
}