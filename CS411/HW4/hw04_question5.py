from DSA import *

q = 18055003138821854609936213355788036599433881018536150254303463583193
p = 17695224245226022262215550436146815259393962370271749288321196346958913355063757122216400038699125897137338245645654623180907445775397476914326454182331200843039828753210051963838673399537750764519381124074022003533048362953579747694997421932628050174768037008419023891955638333683910783296320068313502467953549845629364328685168055331330378439460107262672207911384029916731040428600795952248385683448339051326373879623024586381484917048530867998300839452185045027743182645996068845915287513974737094311071485279830178802332884322953485032954055698263286829168380561154757985319675247125962424242568733265799534941009
g = 4789073941777232663925946116548512236454007195930716545844255515671921902088454647562920559586402554819251607533026386568443177012595965432651516494873094284671880587043080168709792729580864399522070440013588701427100770785527321717784068531253489015313171638446034805847845720567691412760307220603939165634874434595948570583948951567783902643539632274510317008676675644324152107083325484901562104857644621121348409411557653041824973063215599539520882871449851513387270613400464314879652836352363637833225350963794362275261801894957372518031031893668151623517523940210995342229628030114190419396207343174070379971035
B = 1831408160533218510686903726138665932536518466931856989835941853268730468186911958415037229987343935227988816813155415974234360530276380966386586121747340348158553225363319918657949382937198455018294836381584550181800201868806694527418279797492758151769276850910944244395645572497766748854242598561659704665374023326770662512666613356092618904914953512155804252127648818534285831773370510453137952688543495010103660892413395901461238209725480737625047159275781922088076720717434062444236969393756880954396658965471745598003472511293882525516878617801436300794663357187223445935638034452125753926695866508095018852433

m1 = b'The grass is greener where you water it.'
r1 = 16472915699323317294511590995572362079752105364898027834238409547851
s1 = 959205426763570175260878135902895476834517438518783120550400260096

m2 = b'Sometimes you win, sometimes you learn.'
r2 = 14333708891393318283285930560430357966366571869986693261749924458661
s2 = 9968837339052130339793911929029326353764385041005751577854495398266

"""
k2 = 3*k1
=>

h1 = H(m1)
r1 = (g^k1 mod p) mod q
s1 = k1^-1(h1 + ar1) mod q

h2 = H(m2)
r2 = (g^k2 mod p) mod q = (g^(3k1) mod p) mod q 
s2 = k2^-1(h2 + ar2) mod q = (3k1)^-1(h2 + ar2) mod q

3*s2 = 3*(3k1)^-1(h2 + ar2) mod q
     = (k1)^-1(h2 + ar2) mod q

Using the equations above, we can find k1 by solving the equation below:

s1*r2 = k1^-1*h1*r2 + k1^-1*ar1*r2 mod q
3*s2*r1 = k1^-1*h2*r1 + k1^-1*ar2*r1 mod q

=>  subtracting the two equations above
    s1*r2 - 3*s2*r1 = k1^-1(h1*r2 - h2*r1) mod q
    we know h1, h2, r1, r2, s1, s2 and q so we can solve for k1

After we find k1, we can find a by solving the equation below:

s1*h2 = k1^-1*h1*h2 + k1^-1*a*r1*h2 mod q
3*s2*h1 = k1^-1*h1*h2 + k1^-1*a*r2*h1 mod q

=>  subtracting the two equations above
    s1*h2 - s2*h1 = k1^-1*a*r1*h2 - k1^-1*a*r2*h1 mod q
                  = k1^-1*a(h2*r1 - h1*r2) mod q
    we know s1, s2, h1, h2, r1, r2, q, and k1 so we can solve for a
    
"""

## Find k1

h1 = int.from_bytes(SHAKE128.new(m1).read(q.bit_length()//8), byteorder='big')
h2 = int.from_bytes(SHAKE128.new(m2).read(q.bit_length()//8), byteorder='big')

s1r2 = (s1*r2)%q
s2r1_3 = (3*s2*r1)%q

h1r2 = (h1*r2)%q
h2r1 = (h2*r1)%q

dif_hr = (h1r2 - h2r1)%q
dif_sr = (s1r2 - s2r1_3)%q

modinv_dif_hr = modinv(dif_hr, q)

k1_inv = (dif_sr*modinv_dif_hr)%q
k1 = modinv(k1_inv, q)

print("k1:", k1)
print("k2:", 3*k1 % q)

## Find a

s1h2 = (s1*h2)%q
s2h1_3 = (3*s2*h1)%q

r1h2 = (r1*h2)%q
r2h1 = (r2*h1)%q

dif_rh = (r1h2 - r2h1)%q
dif_sh = (s1h2 - s2h1_3)%q

modinv_dif_rh = modinv(dif_rh, q)

a_modinvk = (dif_sh*modinv_dif_rh)%q

a = (a_modinvk*k1)%q

print("a:", a)

# Check whether a is the correct value

test_r1, test_s1 = Sig_Gen(m1, a, k1, q, p, g)
test_r2, test_s2 = Sig_Gen(m2, a, 3*k1, q, p, g)

assert test_r1 == r1
assert test_s1 == s1
assert test_r2 == r2
assert test_s2 == s2

print("a is the correct value")