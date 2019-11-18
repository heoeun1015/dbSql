SELECT *
FROM fastfood;



SELECT king.sido, king.sigungu, king.cnt king_cnt, kfc.cnt kfc_cnt, mac.cnt mac_cnt, lot.cnt lot_cnt,
             TRUNC((NVL(king.cnt,0) + NVL(kfc.cnt,0) + NVL(mac.cnt,0)) / NVL(lot.cnt,0), 2) as buger
FROM (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = '버거킹' GROUP BY sido, sigungu) king,
            (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = 'KFC' GROUP BY sido, sigungu) kfc,
            (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = '맥도날드' GROUP BY sido, sigungu) mac,
            (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = '롯데리아' GROUP BY sido, sigungu) lot
WHERE king.sigungu = kfc.sigungu(+)
     AND king.sigungu = mac.sigungu(+)
     AND king.sigungu = lot.sigungu(+)
     AND king.sido = kfc.sido(+)
     AND king.sido = mac.sido(+)
     AND king.sido = lot.sido
ORDER BY buger desc;

--SELECT king.sido, king.sigungu, king.cnt king_cnt, kfc.cnt kfc_cnt, mac.cnt mac_cnt, lot.cnt lot_cnt,
--             TRUNC((NVL(king.cnt,0) + NVL(kfc.cnt,0) + NVL(mac.cnt,0)) / NVL(lot.cnt,0), 2) as buger
--FROM (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = '버거킹' GROUP BY sido, sigungu) king LEFT JOIN 
--            (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = 'KFC' GROUP BY sido, sigungu) kfc ON
--                   (king.sigungu = kfc.sigungu AND king.sido = kfc.sido) LEFT JOIN 
--            (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = '맥도날드' GROUP BY sido, sigungu) mac ON
--                  (king.sigungu = mac.sigungu AND king.sido = mac.sido) JOIN
--            (SELECT sido, sigungu, count(addr) cnt FROM fastfood WHERE gb = '롯데리아' GROUP BY sido, sigungu) lot ON
--                   (king.sido = kfc.sido AND king.sido = lot.sido)
--ORDER BY buger desc;
