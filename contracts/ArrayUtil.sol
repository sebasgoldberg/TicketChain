pragma solidity ^0.4.24;

library ArrayUtil {

    function sum(uint[] self) public pure returns(uint result) {
        result = 0;
        for (uint i=0; i<self.length; i++){
            result += self[i];
        }
    }

    /** Finds the index of a given value in an array. */
    function indexOf(uint[] self, uint value) public pure returns(uint) {
        uint i = 0;
        while (self[i] != value) {
            i++;
        }
        return i;
    }
 
    /** Removes the given value in an array. */
    function removeByValue(uint[] storage self, uint value) public {
        uint i = indexOf(self, value);
        removeByIndex(self, i);
    }
 
    /** Removes the value at the given index in an array. */
    function removeByIndex(uint[] storage self, uint i) public {
        // @todo Verify if possible to do a swap with the last one
        // instead of the while block.
        while (i<self.length-1) {
            self[i] = self[i+1];
            i++;
        }
        self.length--;
    }
}
