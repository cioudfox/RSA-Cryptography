-- Libary-less Table Dump from StackOverflow(1)
-- Ugly, but convenient for online lua compiler
-- https://stackoverflow.com/a/27028488
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '\n['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Checks if function is prime. Used in primeFactorization
-- Takes in a prime, returns boolean
local function isPrime(n)
  for i = 2, math.sqrt(n) do
    if n % i == 0 then
      return false
    end
  end
  
  return true 
end

-- Calculates the prime factors for p and q values
-- Takes in a prime, returns an array of its prime factors
local function primeFactorization(n)
  local pfactors = {}
  local tempnum = n

  for i = 2, n do
    if isPrime(i) then
      while tempnum % i == 0 do 
        pfactors[#pfactors + 1] = i
        tempnum = tempnum / i
      end
    end
  end

  return pfactors
end

-- Efficient Modular arithmatic Function from Wikipedia (2)
-- Right to Left Method
-- https://en.wikipedia.org/wiki/Modular_exponentiation
local function modPow(b, e, m)
  if m == 1 then
    return 0
  else
    local r = 1
    b = b % m
    while e > 0 do
      if e % 2 == 1 then
        r = (r*b) % m
      end
      b = (b*b) % m
      e = e >> 1     --use 'e = math.floor(e / 2)' on Lua 5.2 or older
    end
    return r
  end
end

-- Simple Calculation for D value with brute force
-- More effective algo would be with Simplified Euclidean Algo
-- Runtime is incredibly inefficient and can take O(e)
local function d_calc(e,n)
  local v = 1 
  local nnum = n 
  local eval = e
  
  while v % eval ~= 0 do
    v = v + nnum
  end

  return v / e
end

-- Encoding Function: S = (msg)^e mod M
function encoding(msgobj, eval, mval)
  local msgval = {}
  
  for i = 1,#msgobj do
    msgval[i] = modPow(msgobj[i],eval,mval)
  end
  
  return msgval
end

-- Decoding Funciton: msg = (S)^d mod M
function decoding(msgobj2, dval, mval)
  local decoded_msg = {}
  for i = 1,#msgobj2 do
    decoded_msg[i] = modPow(msgobj2[i],dval,mval)
  end
  return decoded_msg
end


--[[Variable Definition:
    - Public Info
      - m: Large Product of Primes
      - e: Encryption Key
        - Selection of e must be coprime to k and cannot be greater than k

    - Private Info
      - p,q: prime factors (Can be discarded after)
      - k: Eulers totient (phi(k)) (Can be discarded after)
      - d: Decryption Key (Calculated using p,q,k)
]]
local m = 697
local pfacts = primeFactorization(m)
local p,q = pfacts[1],pfacts[2]

-- Calculate Euler's Totient to solve for d
local k = (p-1) * (q-1)

-- E must be coprime to K
-- Solve for d = e^-1 mod k(Bezouts Identity)
local e = 3
local d = d_calc(e,k)

-- msg = Original, msg2 = Encoded, msg3 = Decoded 
local msg = {8,5,12,12,15,23,15,18,12,4}
local msg2 = {}
local msg3 = {}

print("Original Message", dump(msg))
msg2 = encoding(msg, e, m)
print("\nEncoded Message", dump(msg2))
msg3 = decoding(msg2, d, m)
print("\nDecoded Message", dump(msg3))
