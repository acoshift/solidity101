package main

import (
	"context"
	"fmt"
	"math/big"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/params"
	"github.com/shopspring/decimal"

	"solidity101/backend/abi"
)

//go:generate abigen --abi abi/IERC20.json --pkg abi --type IERC20 --out abi/ierc20.go

var chainID *big.Int
var pk, _ = crypto.HexToECDSA("")

func main() {
	client, _ := ethclient.Dial("https://rei-testnet-rpc.moonrhythm.io")

	chainID, _ = client.ChainID(context.Background())

	usdr := common.HexToAddress("0xa9bcB45E794C7dEb3D2D18eb83EC5f060c835BE4")

	c, _ := abi.NewIERC20(usdr, client)
	balance, _ := c.BalanceOf(nil, common.HexToAddress("0x11117da52457D4fd58C44ce95d0D33B3401E6Eb2"))
	fmt.Println(formatEther(balance))

	tx, _ := c.Transfer(getTxOpts(), common.HexToAddress("0x099FD14bcF9425331CD1894761dC7a718645FE9a"), parseEther("10"))
	fmt.Println(tx.Hash())
	bind.WaitMined(context.Background(), client, tx)

	balance, _ = c.BalanceOf(nil, common.HexToAddress("0x11117da52457D4fd58C44ce95d0D33B3401E6Eb2"))
	fmt.Println(formatEther(balance))
}

func formatEther(v *big.Int) string {
	d := decimal.NewFromBigInt(v, -18)
	return d.String()
}

func parseEther(v string) *big.Int {
	d, _ := decimal.NewFromString(v)
	d = d.Mul(decimal.New(params.Ether, 0))
	fmt.Println(d.BigInt())
	return d.BigInt()
}

func getTxOpts() *bind.TransactOpts {
	txOpts, _ := bind.NewKeyedTransactorWithChainID(pk, chainID)
	return txOpts
}
