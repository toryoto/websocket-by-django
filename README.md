# websocket-by-django
websocketの簡易実装
特徴
- [ ] サーバー側とユーザー側が常にオンライン状態を維持することによって、双方向通信となった
- [ ] 高速
- [ ] 通信量削減
- [ ] TCP上での通信
- [ ] URIスキームがhttp://でなく、ws://

# サーバーを立てるコマンド(asgiサーバー)
```daphne config.asgi:application```
