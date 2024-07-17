from ElGamal import *

q = 1445431254694174381649371259143791311198736690037
p = 137248121434045436247980738953059412416367251619167172965225060439638326312552007992983578734870080149141102688002009860722627928048376753275218309927198296531391131491381377746970705292972549293385978940242862964757496679733959578043293370426396437630135799843979374589693726945392682404824784160383287430661
g = 127223641921850109909544249881449009944648689040286349526712184078921702602665543540563817762837809423359475544561229778960073396175252439333049143438367080170746166373310913545533812707513022571241268299810387846306038162098727078834162806032355796383642287190219288720676739470587659262303423658215573377024

m_1 = b'Believe in the heart of the cards.'
r_1 = 98112636909089823473886804230734608783665151359820285384385184926586779318832342840446756845270685151843520592521030778063107461479185584129724838500026741966009706375181200973944291377753293535599870196345794839828387911579809223830195674821079902123700459948419493000955974605340400274643934795418117953431
t_1 = 76506200278870980622832162087706397184942731175881073072279653879125374026784231243082249838570209197788703418994598663770222774958590484366297473464547976157101536739056638340401709973910922952987332961258414506877745248599494701005790194262083540626575172771336888597402032923407057219028984697739294234494

m_2 = ""
r_2 = 98112636909089823473886804230734608783665151359820285384385184926586779318832342840446756845270685151843520592521030778063107461479185584129724838500026741966009706375181200973944291377753293535599870196345794839828387911579809223830195674821079902123700459948419493000955974605340400274643934795418117953431
t_2 = 95801086901355834240081662719865802187550109851113545620170852280638597493801662857576200633666749663318260607079963837967122188013554434395565196430708343554452720734056250267521097855586180792722796772893530089500987302933561979841152407078582329739116130182358926512269862531407749668332924957717479984854

assert r_1 == r_2 

"""
Since r_1 == r_2, the same k was used to encrypt both messages. This gives us the following equations:
 
b is the private key
B = g^b mod p
r_1 = r_2 = g^k mod p
t_1 = B^k * m_1 = g^b*k * m_1 mod p
t_2 = B^k * m_2 = g^b*k * m_2 mod p

We can find g^b*k by multiplying t_1 with m_1 inverse in mod p.
Later, we can find m_2 by multiplying t_2 by g^b*k inverse in mod p.
"""

enc_m1 = int.from_bytes(m_1, byteorder='big')
modinv_m1 = modinv(enc_m1, p)
g_b_k = (t_1 * modinv_m1) % p
m_2 = (t_2 * modinv(g_b_k, p)) % p

print("M2:", m_2.to_bytes((m_2.bit_length() + 7) // 8, byteorder='big'))