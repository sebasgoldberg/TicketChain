pragma solidity ^0.4.24;

library ArrayUtil {

    function sum(uint[] self) public pure returns(uint result) {
        result = 0;
        for (uint i=0; i<self.length; i++){
            result += self[i];
        }
    }

    /** Finds the index of a given value in an array. */
    function indexOf(uint[] self, uint value) public pure returns(uint index, bool found) {
        return indexOf(self, value, 0, self.length-1);
    }

    /** Finds the index of a given value in an array. */
    function indexOf(uint[] self, uint value, uint indexFrom, uint indexTo)
        public pure returns(uint index, bool found) {
        uint i = indexFrom;
        while (i<(indexTo+1)) {
            if (self[i] == value)
                return (i, true);
            i++;
        }
        return (0, false);
    }

    /** Removes the given value in an array. */
    function removeByValue(uint[] storage self, uint value) public {
        uint i;
        bool found;
        (i, found) = indexOf(self, value);
        require(found, "Value to be removed not found.");
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

    function isUnique(uint[] self) public pure returns(bool){
        uint i = 0;
        bool found;
        while(i<self.length){
            (,found) = indexOf(self, self[i], i+1, self.length-1); 
            if (found)
                return false;
            i++;
        }
        return true;
    }
}
