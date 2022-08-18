import FungibleToken from "../contracts/standard/FungibleToken.cdc"
import FlowToken from "../contracts/standard/FlowToken.cdc"
import YearbookMinter from "../contracts/YearbookMinter.cdc"

transaction {
  prepare(signer: AuthAccount) {
    let yearbookExists = signer.getCapability(/public/Yearbook)
      .check<&YearbookMinter.Yearbook>()

    if(!yearbookExists){
      let capability = signer
        .borrow<&FlowToken.Vault{FungibleToken.Balance}>(from: /storage/flowTokenVault)!
      let book <- YearbookMinter.createYearbook(capability: capability)
      signer.save(<-book, to: /storage/Yearbook)
      signer.link<&YearbookMinter.Yearbook>(/public/Yearbook, target: /storage/Yearbook)
    }
  }
}