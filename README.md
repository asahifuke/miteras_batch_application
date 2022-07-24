# miteras_batch_application
- MiTERASの土日の一括申請、勤怠時間の乖離理由の一括申請を行います。
- https://www.persol-pt.co.jp/miteras/kintai/

## 使い方
```
$ gem install miteras_batch_application
```

```
$ miteras_batch_application -ec [miteras_login_username] [miteras_login_password] [reasons_for_deviation]
```
- miteras_login_username、miteras_login_passwordは、必須です。MiTERASにログインするときのusernameとpasswordを渡してください。
- -c、-eもしくはその両方を渡してください。
- -cは、土日の休日申請を一括で行う機能です。
- -eは、PCの起動時間と打刻時間に乖離がある日に、乖離理由を入力する機能です。
- reasons_for_deviationは、任意の引数です。乖離理由を指定することができます。初期値は、「slack確認のため」です。
