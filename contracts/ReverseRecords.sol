pragma solidity ^0.8.4;pragma experimental ABIEncoderV2;
import "./Namehash.sol";
import '@bchdomains/lns-contracts/contracts/registry/ENS.sol';
import '@bchdomains/lns-contracts/contracts/registry/ReverseRegistrar.sol';
import '@bchdomains/lns-contracts/contracts/resolvers/Resolver.sol';
contract ReverseRecords {
    ENS ens;
    ReverseRegistrar registrar;
    bytes32 private constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;

    /**
     * The `constructor` takes ENS registry address
     */
    constructor(ENS _ens) {
        ens = _ens;
        registrar = ReverseRegistrar(ens.owner(ADDR_REVERSE_NODE));
    }

    /**
     * Read only function to return ens name only if both forward and reverse resolution are set     *
     */
    function getNames(address[] calldata addresses) external view returns (string[] memory r) {
        r = new string[](addresses.length);
        for(uint i = 0; i < addresses.length; i++) {
            bytes32 _node = node(addresses[i]);
            address resolverAddress = ens.resolver(_node);
            if(resolverAddress != address(0x0)){
                Resolver resolver = Resolver(resolverAddress);
                string memory name = resolver.name(_node);
                if(bytes(name).length == 0 ){
                    continue;
                }
                bytes32 namehash = Namehash.namehash(name);
                address forwardResolverAddress = ens.resolver(namehash);
                if(forwardResolverAddress != address(0x0)){
                    Resolver forwardResolver = Resolver(forwardResolverAddress);
                    address forwardAddress = forwardResolver.addr(namehash);
                    if(forwardAddress == addresses[i]){
                        r[i] = name;
                    }
                }
            }
        }
        return r;
    }

    function node(address addr) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(ADDR_REVERSE_NODE, sha3HexAddress(addr)));
    }

    function sha3HexAddress(address addr) private pure returns (bytes32 ret) {
        addr;
        ret; // Stop warning us about unused variables
        assembly {
            let _lookup := 0x3031323334353637383961626364656600000000000000000000000000000000

            for { let i := 40 } gt(i, 0) { } {
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), _lookup))
                addr := div(addr, 0x10)
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), _lookup))
                addr := div(addr, 0x10)
            }

            ret := keccak256(0, 40)
        }
    }

    /**
     * Read only function to lookup addresses for a certain coinType
     */
    function getAddrs(string[] calldata names, uint coinType) external view returns (bytes[] memory r) {
        r = new bytes[](names.length);
        for(uint i = 0; i < names.length; i++) {
            bytes32 namehash = Namehash.namehash(names[i]);
            address resolverAddress = ens.resolver(namehash);
            if(resolverAddress != address(0x0)){
                Resolver forwardResolver = Resolver(resolverAddress);
                bytes memory forwardAddress = forwardResolver.addr(namehash, coinType);
                if(forwardAddress.length == 0) {
                    continue;
                }
                r[i] = forwardAddress;
            }
        }
        return r;
    }
}