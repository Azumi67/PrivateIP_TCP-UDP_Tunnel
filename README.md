![R (2)](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/a064577c-9302-4f43-b3bf-3d4f84245a6f)
نام پروژه : پرایوت ایپی با چندین تانل
---------------------------------------------------------------
![lang](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/627ecb66-0445-4c15-b2a0-59e02c7f7e09)
**زبان - Languages**

- [زبان English](https://github.com/Azumi67/PrivateIP-Tunnel/tree/main#project-overview--private-ip-with-some-of-its-tunnels)

------------------------
![Update-Note--Arvin61r58](https://github.com/Azumi67/PrivateIP_TCP-UDP_Tunnel/assets/119934376/5d5f31fd-e49c-4030-a346-ad80bc6a2d61)**اپدیت**

- ریست تایمر 6 ساعته برای تانل ها اضافه شد.
- ببینید مشکل قطع شدن تانل را براتون برطرف کرده یا خیر.
------------------

![check](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/13de8d36-dcfe-498b-9d99-440049c0cf14)
**امکانات**
 <div dir="rtl">&bull; ساخت پرایوت ایپی و سرویس پینگ برای برقرار ماندن تانل بین دو سرور</div>
 <div dir="rtl">&bull; تانل TCP برای V2ray و Openvpn</div>
 <div dir="rtl">&bull; تانل UDP با استفاده از FRP و UDP2RAW با استفاده از ایپی 4 و 6 و پرایوت</div>
 <div dir="rtl">&bull; نمایش وضعیت سرویس تانل شما</div>
 <div dir="rtl">&bull; امکان ریست و حذف کردن سرویس</div>
 <div dir="rtl">&bull; وایرگارد، openvpn یا پنل v2ray را در سرور خارج نصب نمایید</div>
  <div dir="rtl">&bull; پشتیبانی از amd64 و arm</div>
 
  -----------------------------------------
  **میتوانید همچنین IP6IP6 و GRE6 و سایر موارد را در لینک زیر نگاه کنید**
  - لینک : https://github.com/Azumi67/6TO4-GRE-IPIP-SIT
- منظور این است که نخست به طور مثال IP6IP6 را راه اندازی کنید و سپس از ایپی های تولید شده (generated) برای ریورس تانل استفاده نمایید.
- آموزش ها را با دقت بخوانید و با ازمون و خطا تانل را انجام دهید.
- -------------------------
  
  ![6348248](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/398f8b07-65be-472e-9821-631f7b70f783)
**آموزش**

 
   
    
 <p align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/d92b4e8f-b368-4938-b639-5efea493e184" alt="Image" />
</p>



<div dir="rtl">&bull; ساخت پرایوت ایپی : از سرور خارج شروع کنید.</div>
 <div dir="rtl">&bull; ایپی 4 خارج و ایران را وارد نمایید</div> 
  <div dir="rtl">&bull; ساب نت 64 را وارد نمایید</div>
   <div dir="rtl">&bull; تعداد ایپی پرایوتی که نیاز دارید را وارد نمایید</div>
    <div dir="rtl">&bull; ایپی های ساخته شده را در notepad برای استفاده در تانل بنویسید</div>
     <div dir="rtl">&bull; به صورت اتوماتیک ایپی پرایوت وسرویس پینگ به منظور جلوگیری از اختلال برای شما ساخته خواهد شد</div>
      <div dir="rtl">&bull; سپس همین مراحل را برای سرور ایران هم انجام بدهید</div>

--------------------------------------

**تانل TCP**
**سرور خارج**
 
<p align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/7e41e495-26f1-48ba-a5f0-76c27369a633" alt="Image" />
</p>
 <div dir="rtl">&bull; نخست سرور ایران را کانفیگ کنید و سپس خارج.</div>
  <div dir="rtl">&bull; هر دو پورت سرور خارج و ایران میتواند یکسان باشد</div>
 <div dir="rtl">&bull; اگر تعداد 2 عدد ایپی پرایوت ساختید و میخواهید از هر دو ایپی پرایوت استفاده نمایید، مقدار 2 را وارد نمایید یا هر مقداری که ساختید.</div>
  <div dir="rtl">&bull; اگر میخواهید چند پرایوت ایپی را به هم دیگر تانل کنید به چندین ایپی پرایوت نیاز دارید. به طور مثال اگر میخواهید که 2 ایپی پرایوت را به هم دیگر تانل کنید، 2 ایپی پرایوت برای خارج و 3 تا برای ایران میخواهید.</div>
   <div dir="rtl">&bull; چرا 3 ایپی پرایوت برای ایران ؟ چون یک عدد از ایپی پرایوت ها برای ارتباط تانل و باقی برای پورت ها استفاده میشود</div>
    <div dir="rtl">&bull; توکن و پورت تانل را وارد نمایید ( مقدار یکسان در سرور خارج و ایران)</div>
       <div dir="rtl">&bull; ایپی پرایوت های خارجتون رو وارد نمایید و پورت tcp خارج و ایران را وارد نمایید.</div>
        <div dir="rtl">&bull; به طور مثال پورت v2ray یا ovpn شما در سرور خارج 8080 میباشد، پورت جدید v2ray شما در سرور ایران 8081 خواهد بود و از این پورت برای ارتباط استفاده خواهید کرد</div>
         <div dir="rtl">&bull;  : شما از ایپی 4 ایران و پورت جدیدی که دادید برای ارتباط استفاده خواهید کرد. IPV4-IRAN:8081   | IPV4-IRAN:8083</div>



---------------------------------------------------------------------



         
  **تانل TCP سرور ایران**
  <div align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/815df23d-5fb4-4f3f-94ac-86ef2f6e3682" alt="Image" />
</div>

 <div dir="rtl">&bull; در سرور خارج از یک ایپی پرایوت ایران برای تانل استفاده کردیم. از 2 ایپی دیگر برای پورت های مختلف در سرور ایران استفاده میکنیم</div>
  <div dir="rtl">&bull; توکن و پورت تانل رو وارد نمایید(مقدار یکسان در سرور خارج و ایران)</div>
   <div dir="rtl">&bull; ایپی پرایوت های ایران را وارد نمایید</div>
    <div dir="rtl">&bull;پورت TCP ایران و خارج را وارد نمایید</div>
     <div dir="rtl">&bull; پورت TCP خارج پورت اصلی شما و پورت TCP ایران پورت جدید شما خواهد بود</div>
   <div dir="rtl">&bull; دقت کنید حتما پورت ها همان مقدار هایی باشد که در سرور حارج وارد کردید</div>
   

   **تانل TCP سرور ایران-روش دوم**
   <div align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/18743315-0b34-48f6-a4ed-791b55cdc8e2" alt="Image" />
</div>

 <div dir="rtl">&bull; در این کانفیگ از یک ایپی پرایوت ایران استفاده میکنیم ولی همچنان از 2 ایپی پرایوت برای سرور خارج استفاده میکنیم.</div>
  <div dir="rtl">&bull; توکن و پورت تانل را وارد نمایید (مقدار یکسان در سرور خارج و ایران)</div>
   <div dir="rtl">&bull; پرایوت ایپی ایران را وارد نمایید. دقت نمایید شما در سرور خارج یک پرایوت ایپی ایران را برای تانل اختصاص داده اید، پس برای همین باید از پرایوت ایپی دوم ایران استفاده نمایید</div>
    <div dir="rtl">&bull; شما برای این کانفیگ با توضیحات بالا به دو ایپی پرایوت خارج و ایران نیاز دارید.</div>
     <div dir="rtl">&bull; چون از یک ایپی پرایوت در سرور ایران استفاده میکنیم، باید از port range استفاده کنیم . به طور مثال پورت خارج = 8080,8082 و پورت ایران = 8081,8083</div>
      <div dir="rtl">&bull; دقت نمایید پورت ها مانند پورت هایی باشد که در سرور خارج وارد کردید</div>



----------------------------------

  **تانل FRP-UDP سرور ایران**

  <p align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/aaaeff9c-4351-42b6-9013-6f21aa1fb2eb" alt="Image" />
</p>
 <div dir="rtl">&bull; نخست سرور ایران را کانفیگ کنید و سپس خارج.</div>
 <div dir="rtl">&bull; در این کانفیگ از یک پرایوت ایپی برای خارج و دو پرایوت ایپی برای ایران استفاده کردیم.</div>
  <div dir="rtl">&bull; چرا دو پرایوت ایپی برای ایران ؟ چون یک ایپی پرایوت ایران برای تانل و ایپی دیگر برای پورت استفاده خواهد شد</div>
   <div dir="rtl">&bull; توکن و پورت تانل را وارد نمایید ( مقدار یکسان برای ایران و خارج)</div>
    <div dir="rtl">&bull; ایپی پرایوت دوم ایران را وارد نمایید. سعی کنید ایپی پرایوت ها در جایی یادداشت کرده باشد</div>
     <div dir="rtl">&bull; پورت وایرگارد اصلی شما 50820 میباشد. وایرگارد در سرور خارج نصب میشود</div>
      <div dir="rtl">&bull; پورت وایرگارد جدید شما 50821 میباشد. endpoint شما به این صورت خواهد بود : IPV4-iran:50821</div>


--------------------------------------
      
**تانل FRP-UDP سرور خارج**
<p align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/e69bb32a-6b1a-4a7b-99c2-eee6f92434ba" alt="Image" />
</p>

 <div dir="rtl">&bull; در این کانفیگ از یک ایپی پرایوت برای خارج استفاده کردم ولی برای ایران باید از 2 ایپی پرایوت استفاده کرد چون یک ایپی پرایوت ایران برای تانل و دیگری برای پورت استفاده خواهد شد</div>
  <div dir="rtl">&bull; ایپی پرایوت ایران برای تانل را وارد نمایید</div>
   <div dir="rtl">&bull; توکن و پورت تانل را وارد نمایید ( مقدار یکسان در سرور خارج و ایران)</div>
    <div dir="rtl">&bull; ایپی پرایوت خارج را وارد نمایید</div>
     <div dir="rtl">&bull; پورت وایرگارد سرور خارج من 50820 میباشد. وایرگارد در سرور خارج نصب شده است</div>
      <div dir="rtl">&bull; پورت وایرگارد جدید شما که به نام پورت وایرگارد ایران در اسکریپت میباشد، 50821 خواهد بود. نیاز به نصب وایرگارد در سرور ایران نمیباشد</div>


  -----------------------------------

**تانل UDP2RAW - سروی خارج**

<p align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/6e86c31a-2485-4fb2-b111-cdbf6418063e" alt="Image" />
</p>

 <div dir="rtl">&bull;نخست سرور خارج را کانفیگ کنید و سپس ایران.</div>
  <div dir="rtl">&bull; تنها نیاز هست که پرایوت ایپی خارج را در سرور ایران وارد نمایید بنابراین تنها به یک ایپی پرایوت برای هر دو سرور خارج و ایران نیاز داریم</div>
   <div dir="rtl">&bull; پورت تانل را بدهید</div>
   <div dir="rtl">&bull; پسورد تانل را وارد نمایید ( در هر دو سرور ایران و خارج یکسان میباشد)</div>
    <div dir="rtl">&bull; پورت وایرگاردی که در سرور خارج مشخص کردید در اینجا وارد نمایید</div>
     <div dir="rtl">&bull;  Raw-mode دلخواه خودتان را انتخاب کنید</div>

-------------------------------------------
**تانل UDP2RAW - سرور ایران**

<p align="right">
  <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/d44e9c46-4623-4ffb-a4bc-2dd507e370da" alt="Image" />
</p>

 <div dir="rtl">&bull; در سرور ایران، پورت تانل را همان مقداری که در سرور خارج گذاشتیم، قرار میدهیم</div>
  <div dir="rtl">&bull; پسورد تانل را وارد میکنید ( در هر دو سرور ایران و خارج یکسان میباشد)</div>
   <div dir="rtl">&bull; ایپی پرایوت خارج را وارد نمایید</div>
   <div dir="rtl">&bull; پورت وایرگاردی که در خارج وارد کردید، اینجا هم وارد نمایید</div>
    <div dir="rtl">&bull; Raw-mode دلخواه خود را انتخاب نمایید</div>
     

-------------------------------
**اسکرین شات**
<details>
  <summary align="right">Click to reveal image</summary>
  
  <p align="right">
    <img src="https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/3a83d4de-9196-410b-af78-671658163f0b" alt="menu screen" />
  </p>
</details>

------------------------------------------
![scri](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/cbfb72ac-eff1-46df-b5e5-a3930a4a6651)
**اسکریپت های کارآمد :**

 <div dir="rtl">&bull; میتوانید از اسکریپت opiran vps optimizer یا هر اسکریپت دیگری استفاده نمایید.</div>
 
 
```
apt install curl -y && bash <(curl -s https://raw.githubusercontent.com/opiran-club/VPS-Optimizer/main/optimizer.sh --ipv4)
```

-----------------------------------------------------
![R (a2)](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/716fd45e-635c-4796-b8cf-856024e5b2b2)
**اسکریپت من**

```
apt install curl -y && bash <(curl -Ls https://raw.githubusercontent.com/Azumi67/PrivateIP_TCP-UDP_Tunnel/main/Private.sh --ipv4)
```


---------------------------------------------
![R (7)](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/42c09cbb-2690-4343-963a-5deca12218c1)
**تلگرام** 
![R (6)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/f81bf6e1-cfed-4e24-b944-236f5c0b15d3) [اپیران](https://github.com/opiran-club)

---------------------------------
![R23 (1)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/18d12405-d354-48ac-9084-fff98d61d91c)
**سورس ها**

![R (6)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/be0dd34c-7b47-4d93-904c-eecf013d7b06) [سورس های FRP](https://github.com/fatedier/frp)

![R (9)](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/33388f7b-f1ab-4847-9e9b-e8b39d75deaa) [سورس های اپیران](https://github.com/opiran-club)

![R (6)](https://github.com/Azumi67/PrivateIP-Tunnel/assets/119934376/8a486a00-c6c3-4b30-ba47-3416f9bc2ab3)[سورس udp2raw](https://github.com/wangyu-/udp2raw/)

-----------------------------------------------------

![youtube-131994968075841675](https://github.com/Azumi67/FRP-V2ray-Loadbalance/assets/119934376/24202a92-aff2-4079-a6c2-9db14cd0ecd1)
**ویدیوی آموزش**

-----------------------------------------

Project Overview : Private IP with some of its tunnels
---------------
