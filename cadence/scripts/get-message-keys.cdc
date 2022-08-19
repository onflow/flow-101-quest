import YearbookMinter from "../contracts/YearbookMinter.cdc"

pub fun main(): [String] {
  return YearbookMinter.allowedMessages.keys
}