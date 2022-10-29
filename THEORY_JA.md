# Cadence と 年鑑コントラクトの紹介 📚

> 🌐 言語: [English](THEORY.md) [简体中文](THEORY_ZH.md)

## はじめに

今日は、基本的なコントラクトを作成することで、Cadence（ケイデンス）の基本を学びます。年鑑のコンセプトを用いて、他のプログラミング言語と比較した場合の Cadence の強みをたくさん説明します。

> 🍬 [Playground](https://play.onflow.org) - [https://play.onflow.org/bbcdce0a-ea52-449f-bc0e-4fddd5079f9e](https://play.onflow.org/bbcdce0a-ea52-449f-bc0e-4fddd5079f9e) に行くち、このコードのサンドボックス内のライブバージョンをすぐに実行できます。

## Step 1 - 基本的なコントラクト

このチュートリアルでは、Flow ブロックチェーンのシミュレーション環境である [Flow Playground](https://play.onflow.org) を使います。
Cadence、トランザクション、スクリプトを試すことができます。

モダンな IDE に必要な機能がすべて備わっています。

- コードのハイライト
- インタラクティブな言語サーバー
- コード補完など

Flow 上で最も基本的なコントラクトを定義してみましょう。最も基本的な形は、次のような一行のコードです。

```jsx
pub contract YearbookMinter{ }
```

これは間違いなく実行可能なコントラクトですが、大したことはできません 😅

コントラクトの中身に、空のリソースを定義して、それを `Yearbook`（年鑑）と呼ぶことにします。

```jsx
pub contract YearbookMinter{
    pub resource Yearbook{ }
}
```

リソースは Cadence に不可欠なコンセプトです。リソースは、EVM や WASM よりも豊富なコンポーザビリティのオプションを提供し、デジタルアセットに最適なものです。リソースというラベルを付けることで、プログラミング環境に対して、このデータ構造は具体的な価値を持つものであり、このデータ構造と相互作用するすべてのコードは、このデータ構造の価値を維持するための一連の特別なルールに従わなければならない、ということを示します。

では、そのルールとは何でしょうか？

- 各リソースは、いつでも正確に 1 つの場所に存在する。リソースは複製されたり、プログラミングのエラーや悪意のあるコードによって誤って削除されることはない。
- リソースの所有は、それが保存されている場所によって定義される。所有を決めるために参照される中央の台帳は存在しない。
- リソース上のメソッドへのアクセスは、所有者に限定される。例えば、Yearbook の所有者だけがそれを削除できます。ただし、所有者は Capability を使うことによって、誰でもそれに署名させることもできます。

前のバージョンと同様に、このコントラクトはリソースの定義を持っているだけです。
このリソースのインスタンスは、プロパティを持ちません。それでは、プロパティを追加しましょう。

Yearbook に他のユーザからのメッセージを保存できるようにし、ユーザが互いの Yearbook にメッセージを残せるようにしたいです。
これを実現するために、`messages` という名前の [ディクショナリ](https://docs.onflow.org/cadence/language/values-and-types/#dictionaries) を定義します。このディクショナリは、他のユーザの [Address](https://docs.onflow.org/cadence/language/values-and-types/#addresses) を `key` として使用し、 `value` を [String](https://docs.onflow.org/cadence/language/values-and-types/#strings-and-characters) として格納します。つまり、ディクショナリの型は `{Address: String}` となります。

> 💡 あなたが Ethereum から来た場合・・・ディクショナリは、Solidity では `mapping` と呼ばれるものです。

必要な変更を加えると、以下のようなコードになります:

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

> 💡 リソースにフィールドを追加したので、すべてのフィールドの初期値を設定する `init` メソッドを実装する必要があります。ここでは、`messages` を空のディクショナリで初期化します。

メッセージのフィールドは `let` キーワードで定義しています。これはイミュータブルであり、他のディクショナリに再割り当てできません。しかし、他のユーザーがメッセージを残せるようにしたいです。ディクショナリの値は、ディクショナリが定義されているスコープ内 (この例では `Yearbook` リソースのボディ) で変更可能です。これを可能にするために、 `leaveMessage` 関数を定義してみましょう:

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

予約されたキーワード `self` を使って、現在のコンテキストの親にアクセスしています。ここでは、 `leaveMessage` 関数を呼び出すのに使われた Yearbook リソースのインスタンスを参照しています。

### Step 1.1 - `minter` を追加する

今、このコントラクトをデプロイしても、誰もこのリソースを使うことはできないでしょう。ここでの問題は、リソースはコントラクトの本体でのみ作成され、そこでその型が定義されている必要があることです。

そこで、シンプルな関数 `createYearbook` を追加することで、この問題を解決します:

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

予約されたキーワード `create` はリソースの新しいインスタンスを作るために用いられます。`<-` 演算子はリソースをある場所から別の場所に移動させるために用いられます。
このアプローチは、リソースの望まれない紛失を防ぐために考案されました。

## Step 2 - コントラクトの改善

### Step 2.1 - より詳細な年鑑

Yearbook にユニークなプロパティがあればあるほど、より面白いものになります！

アカウント間でリソースの受け渡しができるので、`ownerAddress` を定義して、リソースのインスタンス化の際の引数に加えてみましょう:

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

> 💡 この値は、リソースの作成時に一度だけ設定できるようにしていますが、所有者が自由に変更できるように実装することは可能です。

### Step 2.2 - コントラクトのイベント

新しい Yearbook が作成されたときや、誰かがメッセージを残したときに、それを記録するために、例えば、ユーザインタフェースに反映させるために、2 つの [イベント](https://docs.onflow.org/cadence/language/events/#gatsby-focus-wrapper) を発行します。

- `YearbookCreated` イベントは、`Yearbook` リソースの新しいインスタンスが作成されたときに発行されます
- `YearbookSigned` イベントは、ユーザが Yearbook にメッセージを残したときに発行されます

イベントをコントラクト上に定義し、Yearbook の `init` 関数内と `leaveMessage` 関数の最後でイベントを発行することにします。

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

技術的にはイベントは _必須_ のものではないのですが、例えば、ウェブアプリなどでイベントをリッスンして反応させることが可能になります。

### Step 2.3 - 抑制されたメッセージ

我々は、人々がお互いの Yearbook に署名するために使うメッセージの固定リストを提供することによって、荒らしを軽減します。
このリストは `{String: String}` ディクショナリの形で保存されます。

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

`if let` の書き方は [オプショナル・バインディング](https://developers.flow.com/cadence/language/control-flow#optional-binding) と呼ばれ、与えられた messageKey の値が存在することを確認できます。なければ、 `else` ブロックのコードを実行します。この例では、所定のメッセージとともに `panic` を呼び出し、コードの実行を停止させます。

### Step 2.4 - パブリック・パスとエラーメッセージの追加

よりよい探索性を提供するために、インタラクションで使える、よく知られたパブリック・パスとストレージ・パスを追加しましょう。また、共通のエラーメッセージも追加しましょう - これは必須ではなく、トランザクションは `panic` メソッドだけでいつでも実行を停止できますが、良い習慣です！

In order to provide better discoverability, let’s add known public and storage paths, that we would use in our interactions. We also add common error messages - it’s not a necessity and transactions can stop execution at any time via the `panic` method, but a nice practice!

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

これにより、スクリプト内でパスをハードコードすることなく、 `YearbookMinter.publicPath` のようなパスを参照できるようになり、インタラクション間でのパスの一貫性を確保できます。

## Step 3 - インタラクション

さて、コントラクトの準備ができたら、いくつかのインタラクションを定義してみましょう。

- `スクリプト`: コントラクトとアカウントのデータ（つまり、チェーン）をクエリするために使われます。スクリプトはチェーンの状態を変更することはできません。たとえ、コントラクトの状態を変更するようなメソッドを呼び出したとしても、コードの実行後にはその変更は保持されません。
- `トランザクション`: チェーンを _変更する_、つまりアカウントに保存されている情報のステートを変更するために使われます。

### Step 3.1 - 許可されたメッセージを読み取る

コントラクト・コードから、許可されたメッセージのリストを読み取ることができますが、これを行うためのプログラマティックな方法があるはずです。簡単な Cadence スクリプトでこれを実現できます。

> 💡 `0x02` アカウントにデプロイされた改良版コントラクトをインポートしています。

```jsx
import YearbookMinter from 0x02

pub fun main(): [String] {
  return YearbookMinter.allowedMessages.keys
}
```

ディクショナリの `keys` メソッドは、利用可能なすべてのキーを配列として返します。`AllowedMessages` のディクショナリは `{String:String}` 型なので、これを呼び出すと、文字列の配列 - `[String]` が返されます。

### Step 3.2 - アカウントを初期化する

ユーザーに、この楽しいアクティビティに参加してもらうために、新しい `Yearbook` リソースを作成し、署名者のストレージに保存して、一般に利用可能な Capability を公開するトランザクションを作成する必要があります。

また、フェール・セーフ・スイッチを追加して、アカウントがすでに Yearbook を保存して公開しているかどうかをチェックし、既存のものを上書きしないようにします。

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

`.check()` メソッドは、指定されたパスに Capability が存在するか、また適切な型（この例では `<&YearbookMinter.Yearbook>`）かチェックします。

`.save()` メソッドは、新しく作成された Yearbook をストレージに保存します（ここで `move` 演算子（`<-`）が、第一引数にリソースを渡すことに注目してください）。

そして最後に `.link()` メソッドは、一般に公開される Capability を作成して公開します（これは次のトランザクションで使います）。

> 💡 public パスと storage パスを使うことがいかに便利であるか、あなたはおそらくお気づきでしょう。

### Step 3.3 - メッセージを残す

誰かの Yearbook にメッセージを残すには、そのアカウントから公開されている Capability を取得し、アドレスとメッセージ・キーを渡して `leaveMessage` メソッドを呼び出す必要があります。

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

アカウントのアドレスを指定して `getAccount` メソッドを呼び出すと、そのアカウントに対応する `PublicAccount` のインスタンスが返ってきます。これはそのアカウントのパブリックな Capability へのアクセスを提供し、その Yearbook への参照を取得することを可能にします。もし、アカウントに必要な Capability がない場合、トランザクションは `panic` によって、指定されたメッセージと共に実行を停止します。

Yearbook リソースへの参照を `.borrow` した後、 `leaveMessage` を呼び出すことができます。

> 💡 お察しの通り、`signer` 引数に任意のアドレスを与えて、他のアカウントになりすますことは簡単です。今回は取り上げませんが、これを（ある程度）抑制することは可能です。

### Step 3.4 - Yearbook 　のメッセージを取得する

最後に、`Address` 引数を取得し、他の人が残したメッセージをすべて取得しようとするスクリプトを作成しましょう。

ここでも、`getAccount` と `getCapability` の組み合わせで Yearbook リソースへの参照を取得します。そして `messages` フィールドの値を返します。

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

## 各種リソース

- Flow Playground - [https://play.onflow.org/local-project](https://play.onflow.org/local-project)
- Docs: Dictionaries - [https://docs.onflow.org/cadence/language/values-and-types/#dictionaries](https://docs.onflow.org/cadence/language/values-and-types/#dictionaries)
- Docs: Resources - [https://docs.onflow.org/cadence/language/resources/](https://docs.onflow.org/cadence/language/resources/)
- Docs: Events - [https://docs.onflow.org/cadence/language/events/#gatsby-focus-wrapper](https://docs.onflow.org/cadence/language/events/#gatsby-focus-wrapper)

## 完了！

🎉 これで Yearbook コントラクトの基礎がわかりましたね! README.md にあるクエストをクリアして、あなただけの Soulbound の知識証明 NFT を獲得してください。
