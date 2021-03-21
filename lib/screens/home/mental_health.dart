
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';


class MentalHealth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health'),
        //backgroundColor: Colors.redAccent,
      ),
             body: Container(
               decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pytchbg.png'),
              fit: BoxFit.cover,
            ),
          ),
           child: Center( child:  ListView(
          children: <Widget>[
            Card( child: ListTile (
              leading: Icon(Icons.link),
              title: Text('Lifeline'),
              trailing: Icon(Icons.more_vert),
              subtitle: Text('Lifeline is a non-profit organisation that provides free, 24-hour Telephone Crisis Support service in Australia'),
               onTap: () async { const url = 'https://www.lifeline.org.au/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
            Card( child: ListTile (
               leading: Icon(Icons.link),
              title: Text('MensLine'),
              trailing: Icon(Icons.more_vert),
              subtitle: Text('MensLine is a telephone and online counselling service for men with health and relationship concerns.'),

               onTap: () async { const url = 'https://mensline.org.au/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
            Card( child: ListTile (
               leading: Icon(Icons.link),
              trailing: Icon(Icons.more_vert),
              title: Text('Suicide Call Backservice'),
              subtitle: Text('Suicide Call Back Service is a nationwide service that provides professional 24/7 telephone and online counselling to people who are affected by suicide.'),
               onTap: () async { const url = 'https://www.suicidecallbackservice.org.au/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
              Card( child:                  ListTile (
               leading: Icon(Icons.link),
               trailing: Icon(Icons.more_vert),
              title: Text('Beyondblue'),
              subtitle: Text('Beyond Blue is an Australian independent non-profit organisation working to address issues associated with depression, suicide, anxiety disorders and other related mental illnesses.'),
               onTap: () async { const url = 'https://www.beyondblue.org.au/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
              Card( child:                  ListTile (
               leading: Icon(Icons.link),
               trailing: Icon(Icons.more_vert),
              title: Text('Headspace'),
              subtitle: Text('Australian non-profit organisation for youth mental health established by the Australian Government in 2006'),
               onTap: () async { const url = 'https://www.headspace.com/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
               Card( child:                 ListTile (
               leading: Icon(Icons.link),
               trailing: Icon(Icons.more_vert),
              title: Text('Reachout'),
              subtitle: Text('You can get immediate support from a number of organisations which are listed on this page.'),
               onTap: () async { const url = 'https://au.reachout.com/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
                Card( child:                ListTile (
               leading: Icon(Icons.link),
               trailing: Icon(Icons.more_vert),
              title: Text('Department of Heath'),
              subtitle: Text('Your health will benefit as soon as you stop smoking so find out what steps to follow in order to quit. '),
               onTap: () async { const url = 'https://www.health.gov.au/contacts/quitline';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
                Card( child:                                 ListTile (
               leading: Icon(Icons.link),
               trailing: Icon(Icons.more_vert),
              title: Text('Quit.org'),
              subtitle: Text('If you are thinking about quitting or are ready to go smokefree, this site can help people understand your smoking habits and choose the best way to quit.'),
               onTap: () async { const url = 'https://www.quit.org.au/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
                Card( child:                                 ListTile (
               leading: Icon(Icons.link),
               trailing: Icon(Icons.more_vert),
              title: Text('Nicorette'),
              subtitle: Text('Tips, Benefits & Products that Can Help You Quit Smoking for Good, Your Way. Discover The Benefits of Quitting. '),
               onTap: () async { const url = 'https://www.nicorette.com.au/';
                   if (await canLaunch(url)) { await launch(url, forceSafariVC: false);}                 
                   else { throw 'Could not launch $url'; }}, )),
          ],
        ),
             )
             )
          );
          }
        }