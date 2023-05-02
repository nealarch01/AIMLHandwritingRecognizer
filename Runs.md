#  Run Information

## Hyper-parameters: 1 (0m 0s) - Bad Network
- Layers: [784, 543, 200, 24, 1] 
- Learning Rate: 0.06
- Epochs: 5000
- Target Error: 0.001
```
~/De/P/Sw/HandwritingRecognizer/D/HandwritingRecognizer/Build/Products/Debug speedup !2 ❯ ./HandwritingRecognizer
Successfully opened database
Fetching letter 'A'
Normalizing training data
Initializing neural network
Training network..
Target error reached
epoch: 0, learning rate: 0.6, error: 1.0726862880042236e-14
Column 4:
Node {
    collector: 0.9999998964294304
    delta: 0.0
}
Training against '5':
Average: 0.9999938269706522 (Not good)
==============================================
~/De/P/Sw/HandwritingRecognizer/D/HandwritingRecognizer/Build/Products/Debug speedup !2 ❯ ./HandwritingRecognizer                                                                                                                        7s
Successfully opened database
Fetching letter 'A'
Normalizing training data
Initializing neural network
Training network..
Target error reached
epoch: 0, learning rate: 0.6, error: 4.957111852122876e-13
Column 4:
Node {
    collector: 0.9999992959324001
    delta: 0.0
}
==============================================
~/De/P/Sw/HandwritingRecognizer/D/HandwritingRecognizer/Build/Products/Debug speedup !2 ❯ ./HandwritingRecognizer                                                                                                                        6s
Successfully opened database
Fetching letter 'A'
Normalizing training data
Initializing neural network
Training network..
Target error reached
epoch: 0, learning rate: 0.6, error: 2.077354071394246e-09
Column 4:
Node {
    collector: 0.9999544220001383
    delta: 0.0
}
==============================================
```

## Hyper-Parameters 2 (1m 27s)
- Layers: [784, 6, 4, 1]
- Learning Rate: 0.06
- Epochs: 5000
- Target Error: 0.001

```)
epoch: 0, learning rate: 0.6, error: 1.3899229373256243
Target error reached
epoch: 1, learning rate: 0.6, error: 1.5916878103783345e-05
Column 3:
Node {
    collector: 0.9960104037668226
    delta: -1.585452508885958e-05
}
==============================================
```

## Hyper-Parameters 3
- Layers: [784, 250, 4, 1]
- Learning Rate: 0.06
- Epochs: 5000
- Target Error: 0.001

#### Limit (3min 30s) 1000
```
~/De/P/Sw/HandwritingRecognizer/D/HandwritingRecognizer/Build/Products/Debug main !2 ❯ ./HandwritingRecognizer
Creting connection
Successfully opened database
Initializing neural network
Fetching letter 'A'
Normalizing training data
Training network..
epoch: 0, learning rate: 0.6, error: 1.058738774676939
Target error reached
epoch: 1, learning rate: 0.6, error: 0.00021721927178262873
Column 3:
Node {
    collector: 0.9852616394472578
    delta: -0.00021423313604732838
}
==============================================
~/De/P/Sw/HandwritingRecognizer/D/HandwritingRecognizer/Build/Products/Debug main !2 ❯
```

#### LIMIT 50 (47s)
```
~/De/P/Sw/HandwritingRecognizer/D/HandwritingRecognizer/Build/Products/Debug main !2 ❯ ./HandwritingRecognizer
Creting connection
Successfully opened database
Initializing neural network
Fetching letter 'A'
Normalizing training data
Training network..
epoch: 0, learning rate: 0.6, error: 0.06543163758774086
epoch: 1, learning rate: 0.6, error: 0.05142515774080167
epoch: 2, learning rate: 0.6, error: 0.04225692392684608
epoch: 3, learning rate: 0.6, error: 0.03580677535467002
epoch: 4, learning rate: 0.6, error: 0.031030886065422578
epoch: 5, learning rate: 0.6, error: 0.02735715540151998
epoch: 6, learning rate: 0.6, error: 0.024446415568347025
epoch: 7, learning rate: 0.6, error: 0.02208513260659378
epoch: 8, learning rate: 0.6, error: 0.02013231694379039
epoch: 9, learning rate: 0.6, error: 0.018491210006339995
epoch: 10, learning rate: 0.6, error: 0.01709324733548284
epoch: 11, learning rate: 0.6, error: 0.015888514530741048
epoch: 12, learning rate: 0.6, error: 0.01483982706793557
epoch: 13, learning rate: 0.6, error: 0.013918926381000535
epoch: 14, learning rate: 0.6, error: 0.013103960462467111
epoch: 15, learning rate: 0.6, error: 0.012377770589304228
epoch: 16, learning rate: 0.6, error: 0.011726698903264618
epoch: 17, learning rate: 0.6, error: 0.0111397412747273
epoch: 18, learning rate: 0.6, error: 0.010607934336604563
epoch: 19, learning rate: 0.6, error: 0.010123904600201409
Target error reached
epoch: 20, learning rate: 0.6, error: 0.0009874199040891562
Column 3:
Node {
    collector: 0.9685767617186077
    delta: -0.0009606029500512212
}
==============================================
~/De/P/Sw/HandwritingRecognizer/D/HandwritingRecognizer/Build/Products/Debug main !2 ❯                                                                                                                                                  42s

```


