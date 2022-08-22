# Cadence 简介以及 Yearbook 合约说明 📚

> 🌐 Languages: [English](THEORY.md)

## 内容简介

今天我们将通过创建一个基本合约来学习 Cadence 的基础知识。 我们也将使用年鉴 (Yearbook) 的概念来说明 Cadence 相对于其他编程语言的许多优势。

> 🍬 你可以直接跳转到 [Playground](https://play.onflow.org) 来了解例子中的实时代码 - [https://play.onflow.org/bbcdce0a-ea52-449f-bc0e-4fddd5079f9e](https://play.onflow.org/bbcdce0a-ea52-449f-bc0e-4fddd5079f9e)

## Step 1 - 基础合约

在这个教程中，我们将使用到 [Flow Playground](https://play.onflow.org) - 一个 Flow 链的模拟环境，我们可以在其中体验 Cadence合约、事务与脚本。

它还具有现代 IDE 的所有必要功能：

- 代码高亮
- 语言提示服务
- 代码自动补完

现在让我们定义 Flow 上最基本的合约。按照最基本的形式，它可以写作这样的一行：

```jsx
pub contract YearbookMinter{ }
```

这是一个完全可行的合约，虽然它没有多大作用 😅

现在我们在合约中定义一个空资源，并将其称为 `Yearbook`:

```jsx
pub contract YearbookMinter{
    pub resource Yearbook{ }
}
```

资源是 Cadence 中的基本概念。资源释放了比 EVM 或 WASM 更丰富的可组合性可能，并且非常适合数字资产。将某物标记为 “资源” 将告诉编程环境该数据结构是一种有特定价值的东西，并且与该数据结构交互的所有代码都需要遵循一系列特殊规则，以保持该数据结构的价值。

那么，这些规则是什么？

- 每个资源在任何时间都只能存在于一个地方。资源是无法被复制或者意外删除的，无论是通过编程错误亦或是恶意代码。
- 资源的所有权由其存储位置定义。不存在一个中央账本来确定它的所有权。
- 对资源方法的访问仅限于所有者。例如，只有 Yearbook 的所有者可以选择删除它，但所有者可以让任何人通过 Capabilities 让其他人可以进行签名。

就像我们之前的版本一样，目前这个合约只包含资源的定义，尚未包含其他属性。  
那就让我们添加一些！

我们希望年鉴能够存储来自其他用户留言，以便用户可以在彼此的年鉴上留言。  
为了实现这一点，我们将定义一个名为 `messages` 的 [Dictionary](https://developers.flow.com/cadence/language/values-and-types#dictionaries)。它将使用其他用户的 [Address](https://developers.flow.com/cadence/language/values-and-types#addresses) 作为 `key` 并将 `value` 存储为 [String](https://developers.flow.com/cadence/language/values-and-types#strings-and-characters) 。所以我们的字典类型将是`{Address: String}`。

> 💡 如果你来自以太坊，Dictionary 在 Solidity 中将被称为 `mapping`。
>

进行必要的更改后，我们的代码应如下所示：

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

> 💡 注意，由于我们已经向资源中添加了字段，我们还需要实现 `init` 方法，该方法将为所有定义的字段设置初始值。所以我们用空字典初始化我们的 `messages` 。

我们用 `let` 关键字定义了 `messages` 字段，声明它是不可变的 —— 即不能再给重新分配另一个新的值，
但我们希望其他用户能够给我们留言，而修改 Dictionary 内的值是被允许的。
在我们的例子中，`Yearbook` 资源的定义内，我们可以定义一个 `leaveMessage` 函数来启用它：

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

我们使用保留关键字 `self` 来访问当前上下文的父级 - 这里它将引用 Yearbook 资源的实例，用于在我们的 `leaveMessage` 函数中被调用。

### Step 1.1 - 添加一个 `minter`

即使我们现在部署这个合约，也没有人能够使用这个资源，原因是资源只能在定义它的合约中进行创建。

为了解决这个问题，我们可以添加一个简单的方法 `createYearbook`：

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

保留关键字`create`用于构造资源的新实例，`<-`运算符用于将资源从一个地方“移动”到另一个地方。  
这种方法旨在防止意外的资源丢失。

## Step 2 - 合约改进

### Step 2.1 - 更详细的年鉴

将有更多独特的属性将被加进年鉴 —— 更多有趣的内容！

由于资源可以在账户之间转移，让我们定义 `ownerAddress` 并在资源初始化期间将其作为参数传入：

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

> 💡 我们只允许在资源创建期间设置这些值一次，但也可以用可令所有者能修改的方式实现它。

### Step 2.2 - 合约事件

为了跟踪创建年鉴或他人留言的时间，比如说，为了在用户界面中体现这些内容。 我们可以定义两个事件 [Events](https://developers.flow.com/cadence/language/events#gatsby-focus-wrapper):

- `YearbookCreated` 将在新的 `Yearbook` 资源实例被创建时发射。
- `YearbookSigned` 将在用户在年鉴中留下留言时发射。

我们把事件都放在合约实现的最顶端，然后在 Yearbook 的 `init` 方法和 `leaveMessage` 方法的末尾发射它们：

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

从技术上讲，您*不需要*事件，但很多情况下你可以通过监听这些事件来做出一些反馈，比如说在 Web 应用中。

### Step 2.3 - 预制留言

我们将通过提供人们可以用来签署彼此年鉴的固定留言列表来减少网络攻击。  
该列表将以 `{String: String}` 字典的形式存储。

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

`if let` 结构被称为可选绑定 [Optional Binding](https://developers.flow.com/cadence/language/control-flow#optional-binding) 它将允许我们确保提供的键对应值的存在性，否则我们将执行 `else` 块中的代码 —— 在我们的例子中，我们将调用带有特定消息的`panic` 来停止代码执行。

### Step 2.4 - 添加 PublicPath 和错误消息

为了提供更好的可发现性，让我们添加一下 PublicPath 和 StoragePath ，我们将在交互中使用它们。  
我们还添加了一些错误消息常量 —— 这不是必需的，交易事务可以通过 `panic` 方法随时停止执行，但这是一个很好的开发实践！

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

虽然它额外添加了几行，但它使我们可以使用像 `YearbookMinter.publicPath` 这样的方式获取路径，这将确保交互时路径的一致性，也无需在脚本中使用硬编码。

## Step 3 - 交互

我们已经准备好了合约，现在让我们来定义一些交互内容。

- 查询脚本 `Scripts`: 用于从合约和账户（即链）中查询数据。 脚本不能修改链的状态。 即使你调用合约上的方法，它可能会改变状态，但这些改变在代码执行后不会被保留。
- 交易事务 `Transactions`: 用于*更改*链状态，即更改存储在帐户上的信息的状态。

### Step 3.1 - 读取预设留言

我们可以从合约代码中读到预设的留言列表，我们也需要用程序化的方法做到这一点。  
通过简单的 Cadence 脚本就可以实现这一点：

> 💡 在脚本开头我们将导入部署到 `0x02` 账户的合约
>

```jsx
import YearbookMinter from 0x02

pub fun main(): [String] {
  return YearbookMinter.allowedMessages.keys
}
```

字典上的 `keys` 方法会将所有可用的键作为数组返回。  
由于我们的 `allowedMessages` 字典类型为 `{String:String}` ，调用它将返回我们的字符串数组 - `[String]`

### Step 3.2 - 初始化账户

既然我们希望用户参与到这个有趣的活动中来，那我们就需要创建一个交易，它将创建新的 `Yearbook` 资源，并将其存储在签名者的存储空间中，然后公开其可用的能力(capability)。

我们还将添加一个安全检查，它将检查帐户是否已经拥有了年鉴资源以防止覆盖现有的内容：

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

`.check()` 方法将检查提供的路径上的能力(capability)是否存在并且类型正确 —— 在我们的例子中它应该是 `<&YearbookMinter.Yearbook>`

`.save()` 方法会将新创建的年鉴存储到存储空间中（注意 `move` 运算符 - `<-` - 这里将资源作为第一个参数传递）

最后，`.link()` 方法将创建并暴露出公开可用的能力(capability) —— 我们将在后续交易事务中使用。

> 💡 你可能已经注意到此时使用这些公共和存储路径是多么方便 —— 你不需要记住它们或参考合约代码，IDE 也会给你代码建议！
>

### Step 3.3 - 留言

为了在某人的年鉴中留言，我们需要从该帐户中获取公开的能力(capability)并调用 `leaveMessage` 方法，传入我们的地址和留言键。

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

`getAccount` 方法被调用后将返回与该帐户对应的 `PublicAccount` 实例。 这将使我们能够访问它的公开能力(capability)，并获取到年鉴实例的引用。  
如果帐户中没有我们想要的能力(capability)，那么交易将会带着错误信息走 `panic` 停止执行。

在我们成功地 `.borrow` 到一个对年鉴资源的引用之后，我们就可以调用 `leaveMessage` 了。

> 💡 正如您可能已经猜到的那样，目前的例子中可以提供*任何*地址来冒充另一个帐户并欺骗 `signer` 参数。实际上是有方法规避这种情况的，但这次我们并不会涉及到它。
>

### Step 3.4 - 获取年鉴留言

最后，让我们创建一个脚本，它将接受 `Address` 参数并尝试获取其他人留下的所有留言。

同样，我们将使用 `getAccount` 和 `getCapability` 的组合获取对年鉴资源的引用，然后返回 `messages` 字段的值。

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

## 参考资料

- Flow Playground - [https://play.onflow.org/local-project](https://play.onflow.org/local-project)
- 文档: Dictionaries - [https://developers.flow.com/cadence/language/values-and-types#dictionaries](https://developers.flow.com/cadence/language/values-and-types#dictionaries)
- 文档: Resources - [https://developers.flow.com/cadence/language/resources](https://developers.flow.com/cadence/language/resources)
- 文档: Events - [https://developers.flow.com/cadence/language/events#gatsby-focus-wrapper](https://developers.flow.com/cadence/language/events#gatsby-focus-wrapper)

## 全部完成❗️

🎉 现在你已经知晓了 Yearbook 合约背后的理论了！请确保完成 README.md 中指定的任务来赢取属于你的 Soulbound Proof-of-Knowledge NFT 吧！
