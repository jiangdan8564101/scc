

#include "ClientDefine.h"
#include "PathFinder.h"
#import "MapGridPos.h"

struct CMapGrid
{
    short x;
    short y;
    
    CMapGrid()
    : x( 0 ) , y( 0 )
    {
    }
    
    CMapGrid( short x , short y )
    {
        this->x = x;
        this->y = y;
    }
    
    bool operator == ( const CMapGrid& grid ) const
    {
        return x == grid.x && y == grid.y;
    }
    
    bool operator != ( const CMapGrid& grid ) const
    {
        return x != grid.x || y != grid.y;
    }
};



struct PathNode
{
    CMapGrid    Grid;
    int			f;
    int			g;
    int			n;
    
    PathNode*	Parent;
    
    void	Clear();
    
    PathNode()
    {
        Parent = 0;
        
        f = 0;
        g = 0;
        n = 0;
    }
};



class PathFinder
{
public:
    
    PathFinder();
    
    void        Release();
    void		Init();
    void		InitMap( const char* data , int x , int y );
    void		SetStartEnd( const CMapGrid& s , const CMapGrid& e );
    void        SetMap( const char d , int x , int y );
    
    void		FindPath();
    int			Find( PathNode** v , PathNode* parent );
    int			Find( PathNode** v , PathNode* parent , const CMapGrid& g , int f , int n = 0 );
    
    int			GetIndex( const CMapGrid& g );
    
    void		Clear();
    
    PathNode*	mResult;
    char*		mMap;
    
    
    int			mMaxX;
    int			mMaxY;
    
protected:
private:
    
    int step;
    
    PathNode** PathNodeVector[ 1024 ];
    
    PathNode*	mTop;
    
    
    
    CMapGrid    mStart;
    CMapGrid    mEnd;
    
    PathNode**	mOpenResult;
    PathNode**	mOpen;
    
    int         mOpenCount;
    int         mOpenResultCount;
    
    char*		mClose;
    
    PathNode*	mNodes;
};





int CheckBlock( int d , int c )
{
    switch ( d )
    {
        case DOOR_NORTH:
        {
            if ( ( c & DOOR_SOUTH ) == DOOR_SOUTH )
            {
                return 0;
            }
        }
            break;
            
        case DOOR_SOUTH:
        {
            if ( ( c & DOOR_NORTH ) == DOOR_NORTH )
            {
                return 0;
            }
        }
            break;
            
        case DOOR_WEST:
        {
            if ( ( c & DOOR_EAST ) == DOOR_EAST )
            {
                return 0;
            }
        }
            break;
            
        case DOOR_EAST:
        {
            if ( ( c & DOOR_WEST ) == DOOR_WEST )
            {
                return 0;
            }
        }
            break;
            
        default:
        {
            return c == DOOR_NOPath ? 1 : 0;
        }
            break;
    }
    
    return 1;
}

int PathNodeLess( const void* n1 , const void* n2 )
{
    PathNode* p1 = *( ( PathNode** ) n1 );
    PathNode* p2 = *( ( PathNode** ) n2 );
    
    return p1->g - p2->g;
}

void		PathNode::Clear()
{
    Parent = 0;
    f = 0;
    g = 0;
    n = 0;
    
}




void        PathFinder::Release()
{
    delete[] mNodes;
    
    delete[] mClose;
    
    delete[] mOpen;
    delete[] mOpenResult;
    
    if ( mMap )
    {
        delete[] mMap;
    }
}

void		 PathFinder::Init()
{
    mMaxY = 0;
    mMaxX = 0;
    
    mResult = 0;
    mTop = 0;
    mNodes = 0;
    mMap = 0;
    mClose = 0;
    
    mNodes = new PathNode[ 128 * 128 ];
    
    mClose = new char[ 128 * 128 ];
    mMap = 0;
    
    mOpen = new PathNode*[ 128 ];
    mOpenResult = new PathNode*[ 128 ];
    
    for ( int i = 0 ; i < 128 * 128 ; i++ )
    {
        mClose[ i ] = 0;
    }
    
}


PathFinder::PathFinder()
{
    step = 1;
}


void		PathFinder::InitMap( const char* data , int x , int y )
{
    mMaxX = x;
    mMaxY = y;
    
    int count = 0;
    for ( int i = 0 ; i < y ; i++ )
    {
        for ( int j = 0 ; j < x ; j++ )
        {
            mNodes[ count ].Grid.x = j;
            mNodes[ count ].Grid.y = i;
            
            count++;
        }
    }
    
    if ( mMap )
    {
        delete[] mMap;
        mMap = NULL;
    }
    
    mMap = new char[ x * y + 1 ];
    memcpy( mMap , data , x * y + 1 );
}

void        PathFinder::SetMap( const char d , int x , int y )
{
    mMap[ GetIndex( CMapGrid( x , y ) ) ] = d;
}


void		PathFinder::SetStartEnd( const CMapGrid& s , const CMapGrid& e )
{
    mStart = s;
    mEnd = e;
}


void		PathFinder::FindPath()
{
    if ( mStart == mEnd )
    {
        mResult = 0;
        return;
    }
    
    if ( CheckBlock( 0 , mMap[ GetIndex( mStart ) ] ) )
    {
        mResult = 0;
        return;
    }
    
    Clear();
    
    mOpen[ mOpenCount ] = mNodes + GetIndex( mStart );
    mOpenCount++;
    
    mClose[ GetIndex( mStart ) ] = 1;
    mTop = mOpen[0];
    mTop->Clear();
    
    step = 1;
    int count = 0;
    
    while ( 1 )
    {
        count++;
        PathNode** v1 = mOpen;
        PathNode** v2 = mOpenResult;
        int c = mOpenCount;
        
        if ( step )
        {
            step = 0;
        }
        else
        {
            v1 = mOpenResult;
            v2 = mOpen;
            
            step = 1;
            
            c = mOpenResultCount;
        }
        
        for ( int i = 0 ; i < c ; ++i )
        {
            int n = Find( v2 , v1[i] );
            
            if ( n )
            {
                return;
            }
        }
        
        
        if ( step )
        {
            mOpenResultCount = 0;
            
            if ( !mOpenCount )
            {
                return;
            }
        }
        else
        {
            mOpenCount = 0;
            
            if ( !mOpenResultCount )
            {
                return;
            }
        }
        
        //v1->clear();
        
        //if ( v2->empty() )
        //{
        ///	return;
        //}
        
        if ( count == 1000 )
        {
            mResult = NULL;
            return;
        }
        
        if ( step )
        {
            qsort( v2 , mOpenCount, sizeof( PathNode* ) , PathNodeLess );
        }
        else
        {
            qsort( v2 , mOpenResultCount, sizeof( PathNode* ) , PathNodeLess );
        }
        
        
        
        //sort( v2->begin() , v2->end() , PathNodeLess );
    }
    
}


int			PathFinder::Find( PathNode** v , PathNode* parent )
{
    // n
    CMapGrid grid = parent->Grid;
    --grid.y;
    int find = Find( v , parent , grid , 10 , DOOR_NORTH );
    if ( find )
        return find;
    
    // s
    grid = parent->Grid;
    ++grid.y;
    find = Find( v , parent , grid , 10 , DOOR_SOUTH );
    if ( find )
        return find;
    
    // w
    grid = parent->Grid;
    --grid.x;
    find = Find( v , parent , grid , 10 , DOOR_WEST );
    if ( find )
        return find;
    
    // e
    grid = parent->Grid;
    ++grid.x;
    find = Find( v , parent , grid , 10 , DOOR_EAST );
    if ( find )
        return find;
    
    //        // nw
    //        grid = parent->Grid;
    //        --grid.x;
    //        --grid.y;
    //        find = Find( v , parent , grid , 14 , 1 );
    //        if ( find )
    //            return find;
    //
    //        // ne
    //        grid = parent->Grid;
    //        ++grid.x;
    //        --grid.y;
    //        find = Find( v , parent , grid , 14 , 2 );
    //        if ( find )
    //            return find;
    //
    //        // sw
    //        grid = parent->Grid;
    //        --grid.x;
    //        ++grid.y;
    //        find = Find( v , parent , grid , 14 , 3 );
    //        if ( find )
    //            return find;
    //
    //        // se
    //        grid = parent->Grid;
    //        ++grid.x;
    //        ++grid.y;
    //        find = Find( v , parent , grid , 14 , 4 );
    //        if ( find )
    //            return find;
    
    return 0;
}


int			PathFinder::Find( PathNode** v , PathNode* parent , const CMapGrid& g , int f , int n )
{
    int index = GetIndex( g );
    
    if ( index != -1 )
    {
        if ( mClose[ index ] != 1 )
        {
            if ( !CheckBlock( n , mMap[ index ] ) )
            {
                //                    switch ( n )
                //                    {
                //                        case 1:
                //                        {
                //                            CMapGrid g1 = g;
                //                            g1.x++;
                //                            CMapGrid g2 = g;
                //                            g2.y++;
                //
                //                            int index1 = GetIndex( g1 );
                //                            int index2 = GetIndex( g2 );
                //
                //                            if ( CheckBlock( mMap[ index1 ] ) && CheckBlock( mMap[ index2 ] ) )
                //                            {
                //                                //mClose[ index ] = 1;
                //                                return 0;
                //                            }
                //                        }
                //                            break;
                //                        case 2:
                //                        {
                //                            CMapGrid g1 = g;
                //                            g1.x--;
                //                            CMapGrid g2 = g;
                //                            g2.y++;
                //
                //                            int index1 = GetIndex( g1 );
                //                            int index2 = GetIndex( g2 );
                //
                //                            if ( CheckBlock( mMap[ index1 ] ) && CheckBlock( mMap[ index2 ] ) )
                //                            {
                //                                //mClose[ index ] = 1;
                //                                return 0;
                //                            }
                //                        }
                //                            break;
                //                        case 3:
                //                        {
                //                            CMapGrid g1 = g;
                //                            g1.x++;
                //                            CMapGrid g2 = g;
                //                            g2.y--;
                //
                //                            int index1 = GetIndex( g1 );
                //                            int index2 = GetIndex( g2 );
                //
                //                            if ( CheckBlock( mMap[ index1 ] ) && CheckBlock( mMap[ index2 ] ) )
                //                            {
                //                                //mClose[ index ] = 1;
                //                                return 0;
                //                            }
                //                        }
                //                            break;
                //                        case 4:
                //                        {
                //                            CMapGrid g1 = g;
                //                            g1.x--;
                //                            CMapGrid g2 = g;
                //                            g2.y--;
                //
                //                            int index1 = GetIndex( g1 );
                //                            int index2 = GetIndex( g2 );
                //
                //                            if ( CheckBlock( mMap[ index1 ] ) && CheckBlock( mMap[ index2 ] ) )
                //                            {
                //                                //mClose[ index ] = 1;
                //                                return 0;
                //                            }
                //                        }
                //                            break;
                //                    }
                
                mNodes[ index ].n = parent->n + 1;
                mNodes[ index ].f = f;
                mNodes[ index ].g = parent->g + f;
                mNodes[ index ].Parent = parent;
                
                if ( step )
                {
                    v[ mOpenCount ] = mNodes + index;
                    mOpenCount++;
                }
                else
                {
                    v[ mOpenResultCount ] = mNodes + index;
                    mOpenResultCount++;
                }
                //v->push_back( mNodes + index );
                
                if ( g == mEnd )
                {
                    mResult = mNodes + index;
                    return 1;
                }
                
                mClose[ index ] = 1;
            }
        }
        
    }
    
    return 0;
}


int			PathFinder::GetIndex( const CMapGrid& g )
{
    if ( g.x >= mMaxX || g.y >= mMaxY ||
        g.x < 0 || g.y < 0 )
    {
        return -1;
    }
    
    return g.y * mMaxX + g.x;
}


void		PathFinder::Clear()
{
    mResult = 0;
    
    if ( mTop )
    {
        mTop->Clear();
        mTop = 0;
    }
    
    mOpenCount = 0;
    mOpenResultCount = 0;
    
    //mOpenResult.clear();
    //mOpen.clear();
    
    for ( int i = 0 ; i < mMaxX * mMaxY * sizeof(char) ; i++ )
    {
        mClose[ i ] = 0;
    }
    
    //memset( mClose , 0 , mMaxX * mMaxY * sizeof(char) );
}


//void initMap( char* val , int x , int y )
//{
//    g_Finder.InitMap( val , x , y );
//
//}
//
//int* findPath( int sX , int sY , int eX , int eY )
//{
//	g_Finder.SetStartEnd( MapGrid(eX , eY) , MapGrid(sX , sY) );
//	g_Finder.FindPath();
//
//    int count = 0;
//    PathNode* node = g_Finder.mResult;
//
//    while ( node )
//    {
//        gResult[ count ] = g_Finder.GetIndex( node->Grid );
//        node = node->Parent;
//    }
//
//	return gResult;
//}
//
//
////entry point for code
//void initFinder()
//{
//	g_Finder.Init();
//}



@implementation PathFinderO



- ( NSMutableArray* ) compressePath:( NSMutableArray* )array
{
    //NSLog( @"1  %@" , array );
    
    [ pathArray removeAllObjects ];
    
    MapGrid* grid1 = [ [ MapGrid alloc ] init ];
    MapGrid* grid2 = [ [ MapGrid alloc ] init ];
    
    int index1 = [ [ array objectAtIndex:0 ] intValue ];
    int index2 = [ [ array objectAtIndex:1 ] intValue ];
    
    grid1.PosX = [ self getX:index1 ];
    grid1.PosY = [ self getY:index1 ];
    grid2.PosX = [ self getX:index2 ];
    grid2.PosY = [ self getY:index2 ];
    
    int lastDirect = [ MapGridPos getDirect:grid1 :grid2 ];
    
    [ pathArray addObject:[ NSNumber numberWithInt:index1 ] ];
    
    for ( int i = 2 ; i < array.count ; i++ )
    {
        index1 = index2;
        grid1.PosX = grid2.PosX;
        grid1.PosY = grid2.PosY;
        
        index2 = [ [ array objectAtIndex:i ] intValue ];
        grid2.PosX = [ self getX:index2 ];
        grid2.PosY = [ self getY:index2 ];
        
        int direct = [ MapGridPos getDirect:grid1 :grid2 ];
        
        if ( lastDirect == direct )
        {
            continue;
        }
        else
        {
            [ pathArray addObject:[ NSNumber numberWithInt:index1 ] ];
        }
        
        lastDirect = direct;
    }
    
    [ pathArray addObject:[ NSNumber numberWithInt:index2 ] ];
    
    //NSLog( @"2  %@" , gPathArray );
    
    [ grid1 release ];
    [ grid2 release ];
    
    //    NSMutableArray* array1 = [ [ NSMutableArray alloc ] init ];
    //    for ( int i = 0 ; i < gPathArray.count ; i++ )
    //    {
    //        [ array1 addObject:[ gPathArray objectAtIndex:i ] ];
    //    }
    //
    //    [ self uncompressePath:array1 ];
    //    NSLog( @"3  %@" , gPathArray );
    
    return pathArray;
}


- ( NSMutableArray* ) uncompressePath:( NSArray* )array
{
    [ pathArray removeAllObjects ];
    
    MapGrid* grid1 = [ [ MapGrid alloc ] init ];
    MapGrid* grid2 = [ [ MapGrid alloc ] init ];
    
    int index1 = [ [ array objectAtIndex:0 ] intValue ];
    grid1.PosX = [ self getX:index1 ];
    grid1.PosY = [ self getY:index1 ];
    
    //[ gPathArray addObject:[ NSNumber numberWithInt:index1 ] ];
    
    for ( int i = 1 ; i < array.count ; i++ )
    {
        int index2 = [ [ array objectAtIndex:i ] intValue ];
        
        grid2.PosX = [ self getX:index2 ];
        grid2.PosY = [ self getY:index2 ];
        
        int direct = [ MapGridPos getDirect:grid2 :grid1 ];
        
        switch ( direct ) 
        {
            case MG_EAST:
                for ( int j = 0 ; j < grid2.PosX - grid1.PosX ; j++ ) 
                {
                    [ pathArray addObject:[ NSNumber numberWithInt:[ self getIndex:grid1.PosX + j :grid1.PosY ] ] ];
                }
                break;
            case MG_SOUTH:
                for ( int j = 0 ; j < grid2.PosY - grid1.PosY ; j++ ) 
                {
                    [ pathArray addObject:[ NSNumber numberWithInt:[ self getIndex:grid1.PosX  :grid1.PosY + j ] ] ];
                }
                break;
            case MG_WEST:
                for ( int j = 0 ; j < grid1.PosX - grid2.PosX ; j++ ) 
                {
                    [ pathArray addObject:[ NSNumber numberWithInt:[ self getIndex:grid1.PosX - j :grid1.PosY ] ] ];
                }
                break;
            case MG_NORTH:
                for ( int j = 0 ; j < grid1.PosY - grid2.PosY ; j++ ) 
                {
                    [ pathArray addObject:[ NSNumber numberWithInt:[ self getIndex:grid1.PosX  :grid1.PosY - j ] ] ];
                }                
                break;
            
            default:
                assert( 0 );
                return pathArray;
                break;
        }      
        
        
        
        grid1.PosX = grid2.PosX;
        grid1.PosY = grid2.PosY;
        index1 = index2;
    }
    
    [ pathArray addObject:[ NSNumber numberWithInt:index1 ] ];
    
    [ grid1 release ];
    [ grid2 release ];
    
    return pathArray;
}

- ( int ) getX:( int )index
{
    return index % finder->mMaxX;
}
- ( int ) getY:( int )index
{
    return index / finder->mMaxX;
}
- ( int ) getIndex:( int ) x :( int )y
{
    return y * finder->mMaxX + x;
}




- ( void ) initFinder
{
    pathArray = [ [ NSMutableArray alloc ] init ];
    
    finder = new PathFinder();
    finder->Init();
}


- ( void ) releaseFinder
{
    [ pathArray release ];
    finder->Release();
}

- ( void ) setMapMaxXY:( int )x :( int )y
{
    finder->mMaxX = x;
    finder->mMaxY = y;
}

- ( void ) initMap:( const char* )val :( int )x : ( int ) y
{
    finder->InitMap( val , x , y );
}

- ( void ) setMap:( const char)v :( int )x :( int )y
{
    finder->SetMap( v , x , y );
}

- ( int ) findPath:(int *)outBuffer :(int)sX :(int)sY :(int)eX :(int)eY
{
    finder->SetStartEnd( CMapGrid(eX , eY) , CMapGrid(sX , sY) );
	finder->FindPath();
    
    int count = 0;
    PathNode* node = finder->mResult;
    
    while ( node )
    {
        outBuffer[ count ] = finder->GetIndex( node->Grid );
        node = node->Parent;
        count++;
        
        if ( MAX_PATH == count )
        {
            return count - 1;
        }
    }
    
    return count;
}


@end
    
    
