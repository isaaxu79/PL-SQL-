select q.*
  from (Select xmltype('<begin>
    <entry>
        <lastname>gordon</lastname>
        <NumberList>
            <number>100</number>
            <codelist>
                 <code>213</code>
                 <code>214</code>
            </codelist>
            <login>
                 <user>user1</user>
                 <user>user2</user>
            </login>
        </NumberList>
        <address>
            <addresslist>Jl. jalan pelan-pelan ke Bekasi, Indonesia</addresslist>
        </address>
    </entry>
    <entry>
        <lastname>mark</lastname>
        <address>
            <addresslist>Jl. jalan cepet-cepet ke Jakarta, Indonesia</addresslist>
        </address>
    </entry>
</begin>') as dsa from dual ) t
  left join xmltable('/begin/entry'
                      passing t.dsa
                      columns LastName   varchar2(21)  path 'lastname',
                              NumberId   number        path 'NumberList/number',
                              Address    varchar2(201) path 'address/addresslist',
                              CodeList   XmlType       Path 'NumberList/codelist/code',
                              Logins     XmlType       Path 'NumberList/login/user'
                      ) q
    on (1=1) 
  left join xmltable('/code'
                      passing q.CodeList
                      columns CodeId number path '.') s
    on (1=1)
  left join   xmltable('/user'
                        passing q.Logins
                        columns LoginId varchar2(11) path '.') w
    on (1=1)