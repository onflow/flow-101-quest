# Flow 101 クエスト 🪄

> 🌐 他の言語: [English](README.md) [简体中文](README_ZH.md)

このクエストの目的は、Flow 上でスマートコントラクトとインタラクションする練習をすることです。このクエストでは [Yearbook（年鑑）](https://flow-view-source.com/testnet/account/0x63ffd70144f80d07/contract/YearbookMinter) コントラクトと対話することになります。このコントラクトの背景にあるコンセプト（といくつかの Cadence の入門レベルのコンセプト）は [THEORY.md](THEORY_JA.md) で説明しています。

この README には実用的なクエストが含まれています。このクエストをクリアした人には、Soulbound の（※他のアドレスに送付できない）、知識を証明する NFT をプレゼントします。

## クエストの概要 📖

1. テストネットのアカウントを作る
2. スマートコントラクトとインタラクションする

- - トランザクションに署名する（チェーンを変更する）
- - スクリプトを実行する（チェーンをクエリする）

## あなたが学ぶこと 💻

1. Flow 開発者の必須ツールである Flow CLI の使い方を学ぶ
2. Flow テストネットのアカウントを作成する
3. 「Flow Yearbook（Flow 年鑑）」に署名するなどの、トランザクションを送信する！

## 賞品 🏆

[<img src="https://user-images.githubusercontent.com/27052451/187195585-30fc757d-c6c4-4e24-9c31-70f89c4bf2b2.png" width=200 />](https://floats.city/andrea.find/event/482557017)

クエスト達成者全員に、**[特別限定の Soulbound の知識証明 NFT](https://floats.city/andrea.find/event/482557017)** をプレゼントします。この特別な NFT を持っていると、自慢できるだけでなく、Flow 公式 Discord の `completion-gated` チャンネルにアクセスできるようになります。

_注記：今回使う NFT の種類（[FLOATs](https://floats.city/)）は Instagram でサポートされているため、あなたの Instagram アカウントで NFT 共有機能が有効化されていれば、友人、家族、同僚に達成したことを共有できます。（※ 現状、Instagram で NFT を共有するためには、Dapper Wallet を使う必要があります）_

## よくある質問

#### このクエストの対象者は誰ですか？

どなたでも！前提知識は必要ありません :) すぐに飛び込んできてください！

#### どれくらい時間がかかりますか？

コマンドラインの基本を知っていると仮定すれば、約 15 分ほどで終わります！

## Step 0 - 前提条件

**Flow CLI をインストール / アップデートする**：このクエストを完了するには、Flow CLI が**必要**です。[Flow CLI Install](https://developers.flow.com/tools/flow-cli/install) のドキュメントにアクセスし、指示に従ってください。ターミナルでコマンドをひとつ実行するだけで、インストールできます。すでにインストールされている場合は、最新バージョンであることを確認してください（アップデート方法は、このページを参照してください）。

#### >> [Flow CLI をインストールまたはアップグレードする](https://developers.flow.com/tools/flow-cli/install) <<

**このリポジトリを clone する** （任意）: このリポジトリには、クエストを完了するためのトランザクションとスクリプトがすでに含まれています。このリポジトリを clone することをお勧めします。あるいは、リポジトリをダウンロードするか、必要なファイルを手動で作成することで、クエストを進められます。このコマンドでリポジトリを clone できます:

```sh
git clone https://github.com/onflow/flow-101-quest
cd flow-101-quest
```

## Step 1 - Flow CLI を起動する

作業ディレクトリに移動したら、Flow CLI を初期化し、テストネットにクエリするための設定を行います。

```
flow init
```

このようなものが表示されます:

```
Configuration initialized
Service account: 0xf8d6e0586b0a20c7

Start emulator by running: 'flow emulator'
Reset configuration using: 'flow init --reset'
```

## Step 2 - テストネットのアカウントを作る

Yearbook（年鑑）に署名する前に、自分のアカウントが必要です！幸いなことに、Flow CLI で簡単なコマンドを実行するだけで大丈夫です。

```
flow accounts create
```

流れは以下の通りです:

##### 1. アカウントに名前をつける

新しいアカウントに「hero」という名前を付けて、<kbd>Enter</kbd> を押します。あとは画面に表示される指示に従ってください。

```
Enter an account name: hero
```

> 💡 どのような名前でも構いませんが、私たちはあなたの経験に沿った説明を心がけています。もし、アカウントに別の名前をつける場合は、「hero」でアカウントとアドレスを参照するときに代わりにその名前を使ってください。

##### 2. ネットワークを Flow Testnet に設定する

ひとつスクロール・ダウンして、Flow Testnet を選択し、<kbd>Enter</kbd> を押してください。

```
Use the arrow keys to navigate: ↓ ↑ → ←
? Choose a network:
    Local Emulator
  ▸ Flow Testnet
    Flow Mainnet
```

##### 3. アカウント情報を保存する

その後、確認のステップが表示されます。<kbd>y</kbd> を入力し、<kbd>Enter</kbd> を押してください。

```
✔ Flow Testnet

❗ This command will perform the following:
 - Generate a new ECDSA P-256 public and private key pair.
 - Save the private key to hero.private.json and add it to .gitignore.
 - Create a new account on Flow Testnet paired with the public key.
 - Save the newly-created account to flow.json.


? Do you want to continue? [y/N] y
```

##### 4. テストネットのアカウントに入金する

```
Please complete the following steps in a web browser:
 1. Complete the captcha challenge.
 2. Click the 'Create Account' button.
 3. Return to this window.

✔ Press <ENTER> to open in your browser...: █

```

<kbd>Enter</kbd> を押すと、自動的にブラウザが起動し、アカウント情報が **あらかじめ入力された** [Flow Testnet Faucet](https://testnet-faucet.onflow.org/) が開かれます。

必要なアクションはこれだけです:

（訳注：1. captcha を完了し、2. 「Create Account」ボタンをクリックしたら、3. このコンソールに戻ってください）

```

Please complete the following steps in a web browser:
 1. Complete the captcha challenge.
 2. Click the 'Create Account' button.
 3. Return to this window.

You can also navigate to the link manually: https://testnet-faucet.onflow.org/?key=<key_that_is_pre_populated>

Waiting for your account to be created, please finish all the steps in the browser...

```

![Funding your testnet account from Flow faucet](https://i.imgur.com/P6hyGlk.gif)

##### 6. これで準備万端です！

```
🎉 New account created with address 0xebeb17c521a0d375 and name hero.

Here’s a summary of all the actions that were taken:
 - Added the new account to flow.json.
 - Saved the private key to hero.private.json.
 - Added hero.private.json to .gitignore.
```

すべての手順が終了すると、ディレクトリ内に 2 つの新しいファイルが作られていることに気づくでしょう:

1. `flow.json`
2. `hero.private.json`

Flow CLI は、`hero.private.json` を参照する、設定ファイル (`flow.json`) を自動的に作成しました。このファイルには、新しく作成したテストネットのアカウントの秘密鍵が含まれています。このファイルは自動的に `.gitignore` に追加されるので、誤って重要情報を漏らしてしまうことはありません！

ファイルを確認すると、新しく作成したアカウントのアドレスと秘密鍵が表示されているはずです 👍！

## Step 3 - 授業を始めます！

公式の Flow Yearbook コントラクトはすでにテストネットにデプロイされているので、このクエストでは単に Flow CLI を介して、コマンドラインからそれを操作することにします。Flow View Source（Flow のコントラクト・エクスプローラーのひとつ）で見ることができます。コントラクトを見るには [ここ](https://flow-view-source.com/testnet/account/0x63ffd70144f80d07/contract/YearbookMinter) をクリックしてください。または、コントラクトがどのように動作するかというコンテキストは、[THEORY.md](https://github.com/onflow/flow-101-quest/blob/main/THEORY.md) ファイルを確認してください。

このクエストでは、[理論](https://github.com/onflow/flow-101-quest/blob/main/THEORY.md) を省略し、Flow CLI を使ってスクリプトとトランザクションを操作する方法を紹介します。さあ、行きましょう！

#### 1. アカウントを初期化する

まず、最初のトランザクションを見てみましょう。もしリポジトリを clone している場合、`cadence/transactions/init-account.cdc` にあります。そうでなければ、`init-account.cdc` というファイルを作成して、その中身に以下の Cadence コードを貼り付けてください:

```javascript
import YearbookMinter from 0x63ffd70144f80d07

transaction {
  prepare(signer: AuthAccount) {
    // アカウントにYearbookリソースがあるかどうか確認します。
    let yearbookExists = signer.getCapability(YearbookMinter.publicPath)
      .check<&YearbookMinter.Yearbook>()

    // 見つからない場合、新たに作りましょう
    if(!yearbookExists){
      let book <- YearbookMinter.createYearbook(ownerAddress: signer.address)
      signer.save(<-book, to: YearbookMinter.storagePath)
      signer.link<&YearbookMinter.Yearbook>(YearbookMinter.publicPath, target: YearbookMinter.storagePath)
    }
  }
}
```

では、Flow CLI を使ってこのトランザクションを送信し、`hero` アカウントで署名してみましょう。

```
flow transactions send ./cadence/transactions/init-account.cdc --signer=hero --network=testnet
```

> 注記: このコマンドは、リポジトリを clone している場合のみ動作します。なぜなら、ファイル `./init-account.cdc` は `./cadence/transactions/` に配置されているからです。ディレクトリのどこにいるかによって、上のコマンドのパスを適宜更新してください。例えば、リポジトリのホームディレクトリにファイルを作成した場合、上のコマンドでは代わりに `./init-account.cdc` を使います。

スクリプトを分解してみましょう:

`--signer` フラグは、署名者として `hero` プロフィールを使うように CLI に指示します

`--network` フラグは、やりとりするネットワークを指定します - 今顔の場合、`Testnet` を使います

このステップでは、あなたのアカウントを開始し、Yearbook リソースがまだ存在しない場合は、それを作成します。

**プロ向けのヒント** 👉 トランザクションを実行するたびに、Flow CLI はトランザクションのステータスが **sealed** になるまで、つまり、チェーンに完全にコミットされるまでポーリングします。そのため、トランザクションが終了したら、上にスクロールしてコマンドの結果を確認し、「Status ✅ SEALED」と表示され、その他のエラーがないことを確認します。

#### 2. （年鑑から)メッセージを取得する

お互いの年鑑に残せるメッセージは、礼儀正しいものとなるように制限をいれています。そのため、任意のメッセージの代わりに、メッセージのキーを指定する必要があります。利用可能なキーと対応するメッセージのリストを取得しましょう。

もしリポジトリをクローンしたのなら、ファイルは `cadence/scripts/get-message-keys.cdc` にあります。ゼロから作成する場合は、`get-message-keys.cdc` というファイルを作成し、以下の Cadence のコードを貼り付けてください:

```javascript
import YearbookMinter from 0x63ffd70144f80d07

pub fun main(): {String: String} {
  return YearbookMinter.allowedMessages
}
```

以下の Flow CLI コマンドでスクリプトを実行します:

```
flow scripts execute ./cadence/scripts/get-message-keys.cdc --network=testnet
```

> 注記: ファイル `./init-account.cdc` は `./cadence/scripts/` にあるため、このコマンドはリポジトリを clone している場合のみ動作します。ディレクトリのどこにいるかによって、上のコマンドのパスを適宜更新してください。例えば、リポジトリのホームディレクトリにファイルを作成した場合、上のコマンドでは、代わりに `./get-message-keys.cdc` を使用します。

これで、キーの一覧が表示されます:

```javascript
"hello": "Hello",
"bff": "You are the best friend anyone could ask for!",
"cya": "See you around",
"gator": "Later, aligator!",
"fun": "You make my life fun!"
```

お気に入りのものを選んで、さあ、メインの Flow 年鑑にメッセージを残しましょう!

#### 3. 年鑑に署名する

Flow 年鑑に署名するためには、トランザクション送信が必要です。

- Flow 年鑑のテストネット・アドレス: `0x63ffd70144f80d07`

年鑑に署名するために、以下のコードを実行することになります。もしリポジトリを clone している場合、`cadence/transactions/sign-yearbook.cdc` にファイルがあります。ゼロから作成する場合は、`sign-yearbook.cdc` というファイルを作成し、以下の Cadence コードを貼り付けてください:

```javascript
import YearbookMinter from 0x63ffd70144f80d07

transaction(yearbookOwner: Address, messageKey: String){
    prepare(signer: AuthAccount){
        // 指定されたアドレスの Yearbook へのパブリックな reference と capability を借りる
        let yearbookReference = getAccount(yearbookOwner)
            .getCapability(YearbookMinter.publicPath)
            .borrow<&YearbookMinter.Yearbook>()
            ?? panic(YearbookMinter.errNoYearbook)

        // 年鑑に署名する
        yearbookReference.leaveMessage(signer: signer.address, messageKey: messageKey)
    }
}
```

このトランザクションには 2 つの引数があります:

- `yearbookOwner` - 変更をいれる年鑑の所有者のアドレス
- `messageKey` - 先ほど説明したメッセージのキー

このトランザクションを実行するには、以下のコマンドを使用します。ここでは例として `fun` というメッセージキーを使っていますが、前のセクションのリストの中から好きなものを自由に選んでください。

```
flow transactions send ./cadence/transactions/sign-yearbook.cdc 0x63ffd70144f80d07 fun --signer=hero --network=testnet
```

> 注記: ファイル `sign-yearbook.cdc` は `./cadence/transactions/` にあるため、このコマンドはリポジトリを clone している場合のみ動作します。ディレクトリのどこにいるかによって、上のコマンドのパスを適宜更新してください。例えば、リポジトリのホームディレクトリにファイルを作成した場合、上記のコマンドでは、代わりに `./sign-yearbook.cdc` を使用します。

#### 4. 年鑑からメッセージを読む

#### 年鑑のメッセージを取得する

さらに、他のヒーローたちが残した過去のメッセージもすべて読めます - 自分と他のヒーロー、両方のアカウントから。

これを行うには、`cadence/scripts/` にある `get-messages.cdc` スクリプト・ファイルを使います。そうでなければ、ゼロから作成して、以下の Cadence コードを貼り付けてください:

```javascript
import YearbookMinter from 0x63ffd70144f80d07

pub fun main(owner: Address): {Address: String}{
    // 年鑑の reference（参照）を取得する
    let yearbookReference = getAccount(owner)
        .getCapability(YearbookMinter.publicPath)
        .borrow<&YearbookMinter.Yearbook>()
        ?? panic(YearbookMinter.errNoYearbook)

    // そのメッセージを返す
    return yearbookReference.messages
}
```

年鑑を見て、誰がメッセージを残しているか確認しましょう。

```javascript
flow scripts execute ./cadence/scripts/get-messages.cdc 0x63ffd70144f80d07 --network=testnet
```

> 注記: ファイル `get-messages.cdc` は `./cadence/scripts/` にあるので、このコマンドはリポジトリを clone しているた場合のみ動作します。ディレクトリのどこにいるかによって、上のコマンドのパスを適宜更新してください。例えば、リポジトリのホームディレクトリにファイルを作成した場合、上記のコマンドでは、代わりに `./get-messages.cdc` を使用します。

年鑑に残されたアドレスとメッセージの一覧が表示されるはずです。

`0x63ffd70144f80d07` を自分のアドレスに書き換えて、`hero.private.json` ファイルにあるアドレスから、自分の年鑑に誰がメッセージを残したかを確認することもできます。もしメッセージがない場合は、別のテストネット・アカウントを作成してメッセージを残してみるか、これを友人にシェアしてメッセージを残してもらいましょう！ :)

## Step 4 - メインネットのアカウントを取得して、NFT を受け取ろう！

Soulbound の知識証明 NFT（FLOAT）を届けるために、あなたはメインネット・アカウントのアドレスを送る必要があります。[Float City](https://floats.city/) のウェブページでウォレットを作成して、FLOAT Collection を初期設定するのが最も簡単な方法です。

1. [https://floats.city](https://floats.city) にアクセスします。
2. "Connect Wallet" をクリックします。
3. 選択したウォレットでログイン（賢く選択！ここで選んだウォレットで FLOAT を受け取ります！Instagram で見せびらかせたいなら、Dapper を選んでください）
4. 右上のアドレスをクリック
5. "Account" タブからアドレスをコピー（これがあなたのメインネット・アカウントです！）
6. **重要**: "Account" タブで、初めて FLOAT を受け取る/利用する場合は、必ず "Setup Account" をクリックしてください。

![Gif on how to access mainnet address from https://floats.city](https://i.imgur.com/T7Jy7YM.gif)

## Step 5 - やりました！ 👏

テストネットで最初のトランザクションを送信し、Flow CLI コマンドを活用できました！おめでとうございます。あなたは Flow の熟練した開発者になるための道を順調に進んでいます。Soulbound の知識証明 NFT を受け取るには、以下の情報をフォームに入力してください。

- テストネット・アカウントのアドレス（あなたの作業を検証するため、`hero.private.json` ファイルに記載されています）
- メインネット・アカウントのアドレス（FLOAT を受け取るため）
- メールアドレス（賞品を受け取るために必要）

# [>><img src="https://user-images.githubusercontent.com/27052451/187195585-30fc757d-c6c4-4e24-9c31-70f89c4bf2b2.png" width=30 /> 提出フォーム <<](https://share.hsforms.com/1ouJ1prrSR566_ZuB9krH5Q3u4gy)

_検証プロセスは毎週自動的に処理され、フォーム送信から 1 週間以内にあなたのアカウントに FLOAT が表示される予定です。_

---

# 次のステップ

あなたはクエストを完了しました。さて、次はどうしましょうか？あなたが試みるべきことは、年鑑の周辺に dapp を構築することです。どうすればいいでしょうか？次のステップとして、探索すべきリソースのリストがあります:

### Web3 Dapps の作り方を学ぶ

[](https://academy.ecdao.org/challenges/hello-world)

- [Emerald Academy - Hello World Dapp Challenge](https://academy.ecdao.org/challenges/hello-world)
- [Emerald Academy - Simple NFT Dapp Challenge](https://academy.ecdao.org/challenges/non-fungible-token)
- [Emerald Academy - Simple Fungible Token Challenge](https://academy.ecdao.org/challenges/fungible-token)
- [Buildspace - Flow Track](https://buildspace.so/flow)
- [LearnWeb3 - Flow Track](https://learnweb3.io/courses/18f86037-e600-4933-aa8e-375f26055d53)

### Cadence を使いこなす

- [Flow Playground Cadence Tutorials](https://play.onflow.org)
- [Join the next Cadence Bootcamp](https://academy.ecdao.org/)

### ソーシャル・チャンネル

- [Flow Twitter](https://twitter.com/flow_blockchain)
- [Flow Discord](https://discord.gg/flow)

何か質問があれば、ぜひご連絡ください!
