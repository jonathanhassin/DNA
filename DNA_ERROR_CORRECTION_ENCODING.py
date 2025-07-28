import math
from random import randint

#%% Main body, encode a word step by step


#main decoder
def SynECCRLLEncoder(x,a,L):
    L-=2
    x=str(x)
    u=RLL(x, L)
    m=CalcM(len(u))
    n=m+2
    #print("The size of the encoded word is n=", n, ".")
    #print("The first step is create the word U, which is RLL bound. U is", u, ".")
    t=math.ceil(math.log(m, 4))  
    y=MakeYRLL(u,m)
    a1=(a-InvSyn(y)) % (4*m)
    beta=findbeta(a1,m)
    y=ChangeDigit(y, 0, beta+1)
    a2=a1-beta*m
    z=to_base_4(a2)
    y=ZintoY(z,y,t,m)
    #print ('Second step, creating Y which is Code Correction capable. Y is', y, ".")
    #print("Y follow the equation InvSyn(Y)=", InvSyn(y), "= a % 4m. m is ", m,".")
    ytime=Wordsum(y)
    #print("The next step is check the synthetic run time of Y. The run time is", ytime," and we compare it to 2.5*m, which is", 2.5*m, '.')
    if ytime <= 2.5*m:
        z=ReciprocalDifferential(y)
       # print('No need to reverse Y. We create Z which is D^-1(Y). Z is ',z, ".")
        c=add_ind(z, 't')
    else:
        y=reverse(y)
    #    print("We need to reverse Y. We create Y' which is",y, ".")
        z=ReciprocalDifferential(y)
    #    print("We create Z' which is D^-1(Y'). Z' is ",z, ".")
    #    print("Z' is ",z)
        c=add_ind(z, 'f')
    #print("At the end, we add a suffix so we can tell if the word wass reversed or not, C is out final output. C is", c)
    #print("Sum(Y) or Sum(Y') is less then 2.5m, so the synthenic time of C is bound by 2.5m.") 
    #print("After removing the suffix, Z is of set Ca(m) and Z' is of set Cb(m). We can correct one deleteion (or insertion) error.") 
    #print("The input of the RLL bound is,", L+2,". We work with L-2, and since the code word is under the reciprocal differential function, the final word is ", L+2, "bounded.")
    return c, n  ##now we have a word we need to work on and then return to its original state

#calculate the size of the codeword from the size of the given word to encode
def CalcM(num):
    num+=5 #first two red and three blue index + RLL
    i=2
    while num >= ((math.pow(4,i) -1) ):
        num+=3
        i+=1
    if num==(math.pow(4,i)-2):
        num+=4
    else:
        num+=2
    return num

#%% Functions related to Synthetic time restriction

#this function calculate the synthetic run time of word x
def SynT(word): #synthetic time of a word
    word = str(word)
    sum = firstword(word)
    for i in range(0, len(word)-1):
        if int(word[i+1]) > int(word[i]):
            sum=sum+(int(word[i+1])- int(word[i]))
        else:
            sum=sum+ int(word[i+1])- int(word[i])+4
    return sum

def firstword(word):#מחזיר אות ראשונה
    return int(word[0])


#a function that return z=5-y, which replaced 1-4 and 2-3, which used to lower the synthetic run time    
def reverse(word):
    
    word = str(word)
    newword=""
    for i in range(0,len(word)): 
        newword+= str(5-int(word[i]))
    return newword


#a function that adds 14 or 23 to the beginning of the word, for the synthetic time algoritm    
def add_ind(word, sign):
    if sign=='t':
        return '14' + word
    elif sign=='f':
        return  '23' + word   



#a function that changes a digit. num is the word,d is the digit location, val is the new value
def ChangeDigit(num,d,val):
    num=str(num)
    num_list = list(num)
    num_list[d] = str(val)
    num = ''.join(num_list)
    return num



#removes the top digits, num is how many digits. used to remove the 14,23 which were added.
def remove_top_digits(word, num):
    word = str(word)
    word = word[num:]
    new_number = int(word)
    return new_number
#%% Functions related to the Deletion restore algorithm

#this function take x and return y which is the differential word of x       
def DifferentialWord(word):#מילה דיפרנציאלית
    word = str(word)
    difword=word[0]
    for i in range(1, len(word)):
        add=mod4((int(word[i]) - int(word[i-1])))
        difword += str(add)
    return difword    

#since our alphabet is 1234 and not 0123, this function is often needed during calcs
def mod4(num):
    if num %4 ==0 :
        return 4
    else :
        return num %4
    
#return the sum of all digits of a word   
def Wordsum(word):
    sum=int(word[0]) 
    for i in range(1, len(word)): 
        sum += int(word[i])
    return sum

#D-1(y)=x    
def ReciprocalDifferential(word):#מילה דיפרנציאלית vpfh,
    word = str(word)
    difword=word[0]
    sum=int(word[0])
    for i in range(1, len(word)):
        sum += int(word[i])
        difword += str(mod4(sum))
    return difword    

#the syndrom function of a word, used to determine the set of ECC
def Syn(word):
    word = str(word)
    sum=firstword(word) 
    for i in range(1,len(word)): 
        sum += int(word[i]) * (i+1)
    return sum

#the inverse syndrom function of a word, used to determine the set of ECC
def InvSyn(word):
    word = str(word)
    lengh=len(word)
    sum=0 
    for i in range(0,lengh): 
        sum += int(word[i]) * (lengh-i)
    return sum


#deletion algorithm, uses another function.
def DeletionRestore(n,a,xd):
    yd=DifferentialWord(xd)
    delta= (a - (InvSyn(yd))) % (4*n)
    s=Wordsum(yd)
    gamma= int(mod4(a - InvSyn(yd) ))
    if delta >= 4+s:
        j=findInd(delta,yd,2,n,gamma,xd)
    else:
        if delta<s:
            j=findInd(delta,yd,1,n,gamma,xd)
        else: ##  s<delta<s+4
            j=n
    #print('We found the error! The missing letter is', gamma, " at location", j,"of the word Z.")
    return insert_digit(xd, gamma, j)
    
           
            
# now that we have gamma,a, delta, it is possibe to find j which is the location of deleted digit
#fix- does it work with insertions???!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!     
def findInd(delta,yd,num,n,gamma,xd):
    sumyd=0
    yd=str(yd)
    xd=str(xd)
    j=0
    if num==1: ##case 2a
        while sumyd<delta: 
            sumyd+=int(yd[j])
            j+=1
    else:  ##case2b
        deltaj=0    
        sumyd=Wordsum(yd)
        j=n
        while j>=0:
            deltaj=4*(n-j) + mod4((gamma-int(xd[j-2]))) + sumyd
            if delta==deltaj:
                return j
            sumyd -= int(yd[j-2])
            j-=1
    return j

#inserts a new digit at recieved index        
def insert_digit(word, digit, index):
    word = str(word)
    if index<=1:
        index =0
    else:
        index -= 1
    new_num_str = word[:index] + str(digit) + word[index:]
    return int(new_num_str)       

#a function that checks if word is part of a set.
#a is a and num is n, which is the regular size of words from the code
def Setcheck(word,a,num):
    value=InvSyn(DifferentialWord(word))
    word=str(word)
    check = value % (4*num)
    return (check==a)    

#a function to find beta, which is used in the deletion algorithm
def findbeta(a1,m):
    for i in range(0,4):
        if (i * m) <= a1 and ((i + 1) * m) >= a1:
            return i
        
#gives z for the deletion algorithm
def createZ(a1,m):
    a2 = a1-m*findbeta(a1,m)
    z=to_base_4(a2)
    return z

def to_base_4(n):
    if n == 0:
        return "0"
    base_4 = []
    while n > 0:
        base_4.append(str(n % 4))
        n //= 4
    return ''.join(reversed(base_4))

#function for the full algorithm, step by step from recieving x into output C which is L bounded, runtime limited and ECC
def MakeYRLL(u,m):
    j=0
    ind= math.ceil(math.log(m, 4))
    u=str(u)
    y=''
    array = [""] * m
    array[0]='1'
    array[1]='2'
    array[m-1]='1'
    array[m-2]='2'
    for i in range(1,ind):
        array[m-int(math.pow(4,i))]='1'
        array[m-int(math.pow(4,i))+1]='2'
        array[m-int(math.pow(4,i))-1]='2'
    for i in range(0,m): 
        if array[i]=="" and j<len(u):
            array[i]=u[j]
            j+=1
    for i in range(0,m): 
        y += str(array[i])
    return y

#this function fills the R indices in y with the digits of Z in base 4.
def ZintoY(z,y,t,m):
    for i in range (0,t):
        num=m-int(math.pow(4,i))
        y=ChangeDigit(y,num,((int(z)%10) +1))
        z=int(int(z)/10)
    return y

#%% Functions related to the RLL algorith

def is_power_of_four(n: int) -> bool:
    return n > 0 and (n & (n - 1)) == 0 and (n & 0x55555555) != 0

#a function that turn a number into its base 4 version, for z in the deletion algorithm        
def to_base_4RLL(n):  ####################33need to add back original
    if n == 0:
        return "4444"
    base_4 = []
    while n > 0:
        base_4.append(str(n % 4))
        n //= 4
    for i in range(len(base_4)):
        if base_4[i]=='0':
            base_4[i]='4'
    for i in range(4-len(base_4)):
        base_4+='4'
    return ''.join(reversed(base_4))

def to_base_10(word):
    word=str(word)
    index=0
    lengh=len(word)
    for i in range (0, lengh):
        index+= (int(word[i]) % 4) * math.pow(4,lengh-i-1)
    return index
        
#take a word, and make sure that there is no string of 4^L. adds 4 at the end of the word for checking    
def RLL(word,L):
    word=str(word)
    word+= '4'
    count=i=0
    while i < len(word):
        if word[i]!='4':
            i+=1
        else:
            while word[i]=='4' and count!=L:
                count+=1
                i+=1
                if count ==L or i==len(word):
                    break
            if count!=L:
                count=0
            else:   
                word = word[:(i-count)] + word[(i-count)+L:] + str(to_base_4RLL(i-count))+'1'
                i=i-count-2
                count=0
    #print(word)
    word=ReciprocalDifferential(word) ##important, now that there is 4^L, the x=D(y) is good
    return word

#recive a word which went through the RLL algo, and restore it
def ReverseRLL(word,L):
    word=str(word)
    word=DifferentialWord(word) ##to return to the original state
    lengh=len(word)
    word = list(word)
    add=('4' * L)
    add=list(add)
    while word[lengh - 1]!='4':
        index=''.join(word[lengh - 5:lengh - 1])
        index=int(to_base_10(index))
        word=word[:index]+ add + word[index:lengh - 5]
        lengh=len(word)
    word=word[:lengh - 1]
    return ''.join(word)
    
#function to find most L in a word. not sure if we use it at all             
def FindMaxL(word): 
    countL = 0
    countMax = 0
    word = str(word)
    for i in range(len(word)):  #
        if word[i] == '4':  
            countL += 1        
        else:                 
            countMax = max(countMax, countL)
            countL = 0  
    countMax = max(countMax, countL)
    return countMax

         
#%% Decoding stage

# Main decoding function:
def MainBody_Decoder(wordC,a,l,n):
    m=n-2
    L=l-2
    #c-->z
    [wordZ,ReverseNeeded,InPrefix]=CheckReverse(wordC);
   # print("We start the decoding process. We check the suffix and return Z=", wordZ,".")
    #z-->y
    if len(wordZ) != m and InPrefix==0:
        if ReverseNeeded:
            b=(5*m*((m+1)/2)-a ) % (4*m)
            wordZ=DeletionRestore(m,b,wordZ)
        else:
            wordZ=DeletionRestore(m,a,wordZ)
    wordY=DifferentialWord(wordZ)
    #print("We recieve Y back by Y=DiffWord(Z)=", wordY,".")
    if ReverseNeeded:
        #print("We need to reverse the word.")
        wordY=reverse(wordY)
    #y-->u-->x
   # print("Now new need to remove the redundancy bits and reverse the RLL algorithm.")
    wordX=ReverseRLL(RemoveYRLL(wordY,m),L) 
    print("The original data word X is", wordX,".")
    return  wordX 

#gets word, removes prefix and inverts word if needed
def CheckReverse (word):
    word=str(word)
    ReverseNeeded=InPrefix=0
    if word[:2]=="14":      #prefix is OK and word doesnt need invert
        word = word[2:]
    elif word[:1]=="1" or word[:1]=="4":    #prefix is corrupt and word doesnt need invert
        word = word[1:]
        InPrefix=1
    elif word[:2]=="23":    #prefix is OK and word needs invert
        word=word[2:]
        ReverseNeeded=1
    else:                   #prefix is corrupt and word needs invert
        InPrefix=1
        word=word[1:]
        ReverseNeeded=1
    #print("DEBUG :CheckReverse:word "+str(word))
    return word,ReverseNeeded, InPrefix

#function that removes the redudancy bits from Y        
def RemoveYRLL(wordY,m):
    ind= math.ceil(math.log(m, 4))
    wordY = list(wordY)
    wordY[0]='x'
    wordY[1]='x'
    wordY[m-1]='x'
    wordY[m-2]='x'
    for i in range(1,ind):
        wordY[m-int(math.pow(4,i))]='x'
        wordY[m-int(math.pow(4,i))+1]='x'
        wordY[m-int(math.pow(4,i))-1]='x'
    wordU=""
    for digit in wordY:
        if digit!='x':
            wordU=wordU+digit
    return wordU

       
#%% Auto self-checking functions

def RandX(length):
    return ''.join(str(randint(1, 4)) for _ in range(length))

def remove_digit(word):
    position=randint(0, len(word)-1)
    word = str(word)
    return int(word[:position] + word[position+1:])

def compare(word1, word2):   
   if word1 == word2 :
     # print ("The restorsion was succesful!")
      return 1
   else:
      print ("The restorsion has failed")
      print("original word is " + str(word2))
      return 0

def check(num):
    suc_count=0
    for i in range (1,num+1):
        WordX=RandX(randint(5,180))
        [c,n1]=SynECCRLLEncoder(WordX,Paramater_a,Parameter_L)
        #print ("The original wordX is: " + str(WordX))
       # print ("The valid wordC is: " + str(c))
        c=remove_digit(c)
       # print ("The corrupted wordC is: " + str(c))
        ResWordX=MainBody_Decoder(c,Paramater_a,Parameter_L,n1)
        #print ("The restored wordX is: " + str(ResWordX))
        suc_count+=compare(ResWordX,WordX)
    print ("")
    print (str(suc_count) + " words were succesfuly restored (out of " + str(num) + " words)")
    
    
Paramater_a=30
Parameter_L=4 

#check(100000)

#%% Manual debuging specific word

def remove_digit_i(word,i):
    word = str(word)
    return int(word[:i] + word[i+1:])

CorWord='23141442324213214'
#CorWord='23141442324213214'
OrgWord="4232121"
[OrgC,n1]=SynECCRLLEncoder(OrgWord,Paramater_a,Parameter_L)
print ("The original wordX is: " + str(OrgWord))
print ("The valid wordC is: " + str(OrgC))
MainBody_Decoder(CorWord,Paramater_a,Parameter_L,n1)


  
