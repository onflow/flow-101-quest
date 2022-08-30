
# Flow 101 Quest 🪄

> 🌐 Other Languages: [English](./README.md)

本次任务的目标是学习在 Flow 上与智能合约进行交互。在这个任务中我们将与 [Yearbook](https://flow-view-source.com/testnet/account/0x63ffd70144f80d07/contract/YearbookMinter) 合约进行交互. 该合约背后的设计理论以及一些 Cadence 的概念介绍可以参见 [THEORY.md](./THEORY_ZH.md)。

本 README 包含一个实践任务，任何完成此任务的人都将获得灵魂绑定的知识证明 NFT。

## 任务概述 📖

1. 创建一个测试网账户
2. 与合约进行交互
- - 签名并发送交易（修改链上状态）
- - 执行查询脚本（查询链上状态）

## 你将学到什么？ 💻

1. 了解如何使用 Flow CLI，这是 Flow 开发人员必不可少的工具
2. 在 Flow 上创建一个测试网帐户
3. 发送交易，例如签署 “Flow Yearbook”

## 奖励 🏆

[<img src="https://user-images.githubusercontent.com/27052451/187195585-30fc757d-c6c4-4e24-9c31-70f89c4bf2b2.png" width=200 />](https://floats.city/andrea.find/event/482557017)

所有完成任务者都将获得一个 **[独家的灵魂绑定知识证明 NFT](https://floats.city/andrea.find/event/482557017)**。除了展示作用外，这个特殊的 NFT 也将授予在官方 Flow Discord 特定频道的访问权限。

*注意：我们使用的 NFT 类型 ([FLOATs](https://floats.city/)) 已经在 Instagram 中支持了, 因此若该内容抵达您的帐户，您将能够与您的朋友、家人和同事分享您的成就。*

## 常见问题❓

### 谁有资格参加此任务？

任何人！ 不需要任何前提条件 :) 立即加入！

### 这需要多长时间？

假设您了解命令行的基础知识，大约需要 15 分钟！

## Step 0 - 准备工作

**安装/更新 Flow CLI**：您**需要使用** Flow CLI 来完成此任务。 访问 [Flow CLI 安装](https://developers.flow.com/tools/flow-cli/install) 文档并按照说明进行操作。 您只需在终端中运行一个命令即可安装它。 如果您已经安装了它，请确保它是最新版本（查看该页面以获取更新说明）。

### >> [在开始任务前请装/更新 Flow CLI](https://developers.flow.com/tools/flow-cli/install) <<

**Clone 此仓库** （可选）：此仓库提供了已完成的交易和脚本，推荐的方法是 clone 仓库或者，您可以下载仓库内容或手动创建必要的文件。  
您可以使用以下命令 clone 仓库：

```sh
git clone https://github.com/onflow/flow-101-quest
cd flow-101-quest
```

## Step 1 - 开始 Flow CLI

进入工作目录后，我们将初始化 Flow CLI 并对其进行配置以查询测试网。

```bash
flow init
```

你可以看到类似的内容：

```bash
Configuration initialized
Service account: 0xf8d6e0586b0a20c7

Start emulator by running: 'flow emulator' 
Reset configuration using: 'flow init --reset'
```

## Step 2 - 创建你的测试网账户

在我们签署年鉴之前，我们需要自己的帐户！  
我们只需要使用 Flow CLI 运行一个简单的命令就可以完成。

#### 1. 创建一个测试网账户

```bash
flow accounts create
```

流程如下：

##### 1. 为你的账户设置别名

将您的新帐户命名为 `hero` ，然后按 <kbd>Enter</kbd>。 按照屏幕上的其余说明进行操作。

```bash
Enter an account name: hero
```

> 💡 您可以选择任何名字，我们尽量让指引和您的习惯保持一致。 如果您决定以不同的方式命名您的帐户，请在我们提到 `hero` 帐户和地址的任何地方替换为您的命名。

##### 2. 将网络设置为测试网

```bash
Use the arrow keys to navigate: ↓ ↑ → ← 
? Choose a network: 
    Local Emulator
  ▸ Flow Testnet
    Flow Mainnet
```

##### 3. 保存你的密钥信息

然后，您将看到一个确认步骤。 键入 <kbd>y</kbd> 并按 <kbd>Enter</kbd>。

```bash
✔ Flow Testnet

❗ This command will perform the following:
 - Generate a new ECDSA P-256 public and private key pair.
 - Save the private key to hero.private.json and add it to .gitignore.
 - Create a new account on Flow Testnet paired with the public key.
 - Save the newly-created account to flow.json.


? Do you want to continue? [y/N] y
```

##### 4. 通过水龙头创建账户

```bash
Please complete the following steps in a web browser:
 1. Complete the captcha challenge.
 2. Click the 'Create Account' button.
 3. Return to this window.

✔ Press <ENTER> to open in your browser...: █
```

一旦您按下 <kbd>Enter</kbd>，您的浏览器将自动定向到 [Flow 测试网水龙头](https://testnet-faucet.onflow.org/)，其中您的帐户信息也完成了**预填充**。

唯一需要的操作是根据提示完成账户的创建。

```bash
Please complete the following steps in a web browser:
 1. Complete the captcha challenge.
 2. Click the 'Create Account' button.
 3. Return to this window.

You can also navigate to the link manually: https://testnet-faucet.onflow.org/?key=<key_that_is_pre_populated>

Waiting for your account to be created, please finish all the steps in the browser...
```

![Funding your testnet account from Flow faucet](./assets/testnet_faucet.gif)

##### 5. 你都准备好了！

```bash
🎉 New account created with address 0xebeb17c521a0d375 and name hero.

Here’s a summary of all the actions that were taken:
 - Added the new account to flow.json.
 - Saved the private key to hero.private.json.
 - Added hero.private.json to .gitignore.
```

完成所有步骤后，您会注意到目录中现在出现了 2 个新文件：

1. `flow.json`
2. `hero.private.json`

Flow CLI 自动为我们创建了一个配置文件（`flow.json`），它引用了第二个文件 `hero.private.json`。该文件包含了新创建测试网帐户的私钥。  
该文件会自动添加到 `.gitignore` 中，因此您不会意外泄漏任何隐私信息！

如果您检查文件，您应该会看到新创建帐户的地址和私钥 👍！

## Step 3 - 开始上课！

官方的 Flow Yearbook 合约已经部署到测试网，所以在这个任务中，我们将简单地通过 Flow CLI 从命令行与它进行交互。  
您可以在 Flow View Source（Flow 的合约浏览器之一）上查看它。 点击[这里](https://flow-view-source.com/testnet/account/0x63ffd70144f80d07/contract/YearbookMinter)查看合约。 或者查看 [THEORY.md](./THEORY_ZH.md) 文件以了解合约如何运作的上下文。

在这个任务中，我们将跳过 [THEORY.md](./THEORY_ZH.md) 并向您展示如何使用 Flow CLI 来进行查询脚本和交易事务的交互。  
开始吧！

#### 1. 账户初始化

首先让我们看一下我们的第一笔交易。如果你克隆了 repo，你会在 `cadence/transactions/init-accound.cdc` 中找到它。 否则，只需创建一个名为 `init-account.cdc` 的文件并粘贴并使用以下 Cadence 代码：

```javascript
import YearbookMinter from 0x63ffd70144f80d07

transaction {
  prepare(signer: AuthAccount) {
    // checks if we have a yearbook resource in our account
    let yearbookExists = signer.getCapability(YearbookMinter.publicPath)
      .check<&YearbookMinter.Yearbook>()

    // if it doesn't find one, let's create a new one.
    if(!yearbookExists){
      let book <- YearbookMinter.createYearbook(ownerAddress: signer.address)
      signer.save(<-book, to: YearbookMinter.storagePath)
      signer.link<&YearbookMinter.Yearbook>(YearbookMinter.publicPath, target: YearbookMinter.storagePath)
    }
  }
}
```

现在我们将使用 Flow CLI 发送此交易并使用我们的 `hero` 帐户对其进行签名

```bash
flow transactions send ./cadence/transactions/init-account.cdc --signer=hero --network=testnet
```

> 注意：此命令仅在您克隆 repo 时有效，因为文件 `./init-account.cdc` 位于 `./cadence/transactions/` 中。 根据您在目录中的位置，相应地更新上述命令中的路径。 例如，如果您在仓库的主目录中创建了文件，则应该在上面的命令中使用 `./init-account.cdc`。

让我们来剖析一下这段脚本：

`--signer` 标志将告诉 CLI 使用您的 `hero` 个人资料作为签名者

`--network` 标志将指定我们正在与之交互的网络 - 在这种情况下，我们使用的是 `testnet`

此步骤将初始化您的帐户（如果年鉴资源不存在，将创建一个新的资源实例）。

**专业提示** 👉 每次运行事务时，Flow CLI 都会轮询，直到事务状态为 **sealed**，这意味着它已完全提交到链上。 因此一旦事务完成，可以通过向上滚动来检查结果，看它是否显示“Status ✅ SEALED”并且没有其他错误。

#### 2. 从年鉴中获取留言

为了保持文明，我们限制了人们可以在彼此的年鉴上留下的信息。您需要指定留言键而不是自定义消息。 让我们获取可用键值和相应消息的列表。

如果你 clone 了本仓库，你可以在 `cadence/scripts/get-message-keys.cdc` 中找到文件。 如果您从头开始创建它们，请创建一个名为 `get-message-keys.cdc` 的文件并粘贴以下 Cadence 代码：

```javascript
import YearbookMinter from 0x63ffd70144f80d07

pub fun main(): {String: String} {
  return YearbookMinter.allowedMessages
}
```

使用以下 Flow CLI 命令执行脚本：

```bash
flow scripts execute ./cadence/scripts/get-message-keys.cdc --network=testnet
```

> 注意：此命令仅在您克隆 repo 时才有效，因为文件 `./init-account.cdc` 位于 `./cadence/scripts/` 中。 根据您在目录中的位置，相应地更新上述命令中的路径。 例如，如果您在仓库的主目录中创建了文件，则应在上面的命令中使用 `./get-message-keys.cdc`。

这将为您提供一个键列表：

```javascript
"hello": "Hello",
"bff": "You are the best friend anyone could ask for!",
"cya": "See you around",
"gator": "Later, aligator!",
"fun": "You make my life fun!"
```

选择你最喜欢的，现在让我们在主要的 Flow 年鉴中留言吧！

#### 3. 在 Flow 年鉴中留言

为了在 Flow 年鉴中留言你需要递交一个交易。

- Flow Yearbook 的测试网地址: `0x63ffd70144f80d07`

在 Flow 年鉴中留言，我们将执行下面的代码。 如果您 clone 了本仓库，您将在 `cadence/transactions/sign-yearbook.cdc` 中找到该文件。 如果您从头开始创建它们，请创建一个名为 `sign-yearbook.cdc` 的文件并粘贴以下 Cadence 代码：

```javascript
import YearbookMinter from 0x63ffd70144f80d07

transaction(yearbookOwner: Address, messageKey: String){
    prepare(signer: AuthAccount){
        // borrow the public reference & capability to the Yearbook at the address specified
        let yearbookReference = getAccount(yearbookOwner)
            .getCapability(YearbookMinter.publicPath)
            .borrow<&YearbookMinter.Yearbook>()
            ?? panic(YearbookMinter.errNoYearbook)
        
        // sign the yearbook
        yearbookReference.leaveMessage(signer: signer.address, messageKey: messageKey)
    }
}
```

此交易有两个参数：

- `yearbookOwner`: 我们要去留言的年鉴所有者地址
- `messageKey` - 之前讨论的留言键值

要运行此事务，请使用以下命令。 我们以 `fun` 消息键为例，请随意从上一节的列表中选择您喜欢的。

```bash
flow transactions send ./cadence/transactions/sign-yearbook.cdc 0x63ffd70144f80d07 fun --signer=hero --network=testnet 
```

> 注意：此命令仅在您 clone 了本仓库时才有效，因为文件 `sign-yearbook.cdc` 位于 `./cadence/transactions/` 中。 根据您在目录中的位置，相应地更新上述命令中的路径。 例如，如果您在仓库的主目录中创建了文件，则应该在上面的命令中使用 `./sign-yearbook.cdc`。

#### 4. 阅读年鉴中的留言

#### 获取年鉴留言

此外，您还可以阅读其他 `heros` 留下的留言，他们都来自于您和其他人的账户。

为此，我们将使用 `get-messages.cdc` 脚本文件，您可以在 `cadence/scripts/` 中找到该文件。 否则，从头开始创建并粘贴以下 Cadence 代码：

```javascript
import YearbookMinter from 0x63ffd70144f80d07

pub fun main(owner: Address): {Address: String}{
    // get a reference to the yearbook
    let yearbookReference = getAccount(owner)
        .getCapability(YearbookMinter.publicPath)
        .borrow<&YearbookMinter.Yearbook>() 
        ?? panic(YearbookMinter.errNoYearbook)
    
    // return its messages
    return yearbookReference.messages
}
```

让我们看看我们的年鉴，看看谁在那里留言：

```bash
flow scripts execute ./cadence/scripts/get-messages.cdc 0x63ffd70144f80d07 --network=testnet 
```

> 注意：此命令仅在您 clone 了本仓库时才有效，因为文件 `get-messages.cdc` 位于 `./cadence/scripts/` 中。 根据您在目录中的位置，相应地更新上述命令中的路径。 例如，如果您在仓库的主目录中创建了文件，则应该在上面的命令中使用 `./get-messages.cdc`。

您应该能够看到已留在我们年鉴中的地址列表和相应的留言。

您还可以将 `0x63ffd70144f80d07` 更新为您自己的地址 - 可以在 `hero.private.json` 文件中找到该地址，并检查谁在您的年鉴中留下了消息。 如果您没有任何消息，您可以创建另一个测试网帐户并尝试留下一个，或者与朋友分享并让他们留言！ :)

## Step 4 - 获取一个主网账户来接收你的 NFT！

为了方便向您发放灵魂绑定知识证明 NFT (FLOAT)，您需要向我们递交您的主网帐户地址。 最简单的方法是通过 [Float City](https://floats.city/)，这也可以用于初始化FLOAT 集合。

1. 访问[https://floats.city](https://floats.city)
2. 点击 “Connect Wallet”
3. 选择一个登录的钱包（注意你的选择！这是您接收 FLOAT 的地方！如果您想在 Instagram 上炫耀，请选择 Dapper）
4. 点击右上角的地址框
5. 从 “Account” 选项页中复制你的地址（这是您的主网帐户！）
6. 可选：如果你是第一次接收/使用 FLOAT，请务必确保在该页面完成 FLOAT 集合的初始化创建。

![Gif on how to access mainnet address from https://floats.city](./assets/FLOAT_mainnet.gif)

## Step 5 - 你完成了全部内容！👏

恭喜您完成了 Flow CLI 命令的使用并在 Testnet 上发送第一笔交易！  
您正在成为一名熟练的 Flow 开发人员。 为了获得您的灵魂绑定知识证明 NFT，请填写表格并提供以下信息：

- 测试网帐户地址（用于验证您的工作 - 您可以在您的 `hero.private.json` 文件中找到它）
- 主网账户地址（用于接收 FLOAT）
- 电子邮件地址（如果我们有新的周边，可以通过邮件联系到您！）

# [>> <img src="https://user-images.githubusercontent.com/27052451/187195585-30fc757d-c6c4-4e24-9c31-70f89c4bf2b2.png" width=30 />提交表格 <<](https://share.hsforms.com/1ouJ1prrSR566_ZuB9krH5Q3u4gy)

*验证过程将每周自动处理，您可以在提交表单后约一周内在您的帐户中看到您的 FLOAT*

--------

# 后续内容

您已经完成了任务。  
现在呢？是的，现在您可以尝试去围绕年鉴 Yearbook 构建一个 dapp。  
想知道如何做到嘛？以下便是您后续步骤中该探索的资源列表：

### 学习如何构建 Web3 Dapps

- [Emerald Academy - Hello World Dapp Challenge](https://academy.ecdao.org/challenges/hello-world)
- [Emerald Academy - Simple NFT Dapp Challenge](https://academy.ecdao.org/challenges/non-fungible-token)
- [Emerald Academy - Simple Fungible Token Challenge](https://academy.ecdao.org/challenges/fungible-token)
- [Buildspace - Flow Track](https://buildspace.so/flow)
- [LearnWeb3 - Flow Track](https://learnweb3.io/courses/18f86037-e600-4933-aa8e-375f26055d53)

### 精通 Cadence

- [Flow Playground Cadence 教程](https://play.onflow.org)
- [参加下一场 Cadence Bootcamp](https://academy.ecdao.org/)

### 社交渠道

- [Flow Twitter](https://twitter.com/flow_blockchain)
- [Flow Discord](https://discord.gg/flow)

如果您有任何问题，请务必联系我们！
