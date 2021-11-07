RSA Cryptography 

Our project is based on verilog implementation of RSA encryption , it is a widely known cybersecurity practice which involves 
use of public and private keys (cryptography). to calculate decryption key 'd' and encryption key 'e' we use extended euclidian algorithm  
i.e  d * e = 1 mod (phi)

//Concept of RSA cryptography
OUTPUT is based on the rules (below is an example of general rsa cryptosytem(not bit specific)):
>> Generating Public Key :
Select two prime no's. Suppose P = 53 and Q = 59.
Now First part of the Public key  : n = P*Q = 3127.
 We also need a small exponent say e : *But e Must be An integer, *Not be a factor of n. 
1 < e < Φ(n) [Φ(n) is discussed below], Let us now consider it to be equal to 3.
Our Public Key is made of n and e.

>> Generating Private Key :
We need to calculate Φ(n) :
Such that Φ(n) = (P-1)(Q-1)     
      so,  Φ(n) = 3016
    
>>Now calculate Private Key, d : 
d = (k*Φ(n) + 1) / e for some integer k
For k = 2, value of d is 2011.

>>//For Example:: (Now we are ready with our – Public Key ( n = 3127 and e = 3) and Private Key(d = 2011) as above)
Now we will encrypt “HI” :
Convert letters to numbers : H  = 8 and I = 9
Thus Encrypted Data c = 89^e mod n. 
Thus our Encrypted Data comes out to be 1394

>>Now we will decrypt 1394 : 
Decrypted Data = c^d mod n. 
Thus our Encrypted Data comes out to be 89
8 = H and I = 9 i.e. "HI".

Project Proposal - DONE

Intermediate Submission - DONE (See Intermediate_submission.txt)

Final Submission - IN PROGRESS
